#!/usr/bin/env bash
set -Eeuo pipefail

# Dify 1.15.0 public WebApp redirect hotfix
#
# 功能：
#   1. 定位 web/app/(commonLayout)/hydration-boundary.tsx
#   2. 备份原文件
#   3. 为公开 WebApp 路由跳过 Console Profile/Workspace/System Features 预取
#   4. 幂等执行，重复运行不会重复插入
#
# 使用：
#   chmod +x patch-1.15.0.sh
#   ./patch-1.15.0.sh /path/to/dify
#
# 如果当前目录就是 Dify 源码根目录：
#   ./patch-1.15.0.sh
#
# 注意：
#   这是前端源码补丁。执行后必须重新构建 dify-web 镜像并替换 web 容器。

DIFY_ROOT="${1:-$(pwd)}"
TARGET_REL='web/app/(commonLayout)/hydration-boundary.tsx'
TARGET="${DIFY_ROOT%/}/${TARGET_REL}"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"
BACKUP="${TARGET}.bak.public-webapp.${TIMESTAMP}"

log() {
  printf '[%s] %s\n' "$1" "$2"
}

die() {
  log ERROR "$1" >&2
  exit 1
}

[[ -f "$TARGET" ]] || die "未找到目标文件：$TARGET"

log INFO "Dify 根目录：$DIFY_ROOT"
log INFO "目标文件：$TARGET"

if grep -q 'PUBLIC_WEBAPP_PATH_PREFIXES' "$TARGET"; then
  log SKIP "补丁已存在，无需重复执行"
  exit 0
fi

grep -q "const AUTH_REFRESH_PATH = '/auth/refresh'" "$TARGET" \
  || die "未找到 AUTH_REFRESH_PATH，源码可能不是预期的 Dify 1.15.0 版本"

grep -q 'export async function CommonLayoutHydrationBoundary' "$TARGET" \
  || die "未找到 CommonLayoutHydrationBoundary 函数"

cp -a "$TARGET" "$BACKUP"
log BACKUP "$TARGET -> $BACKUP"

python3 - "$TARGET" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
content = path.read_text(encoding="utf-8")

constant_marker = """const AUTH_REFRESH_PATH = '/auth/refresh'
"""

constant_replacement = """const AUTH_REFRESH_PATH = '/auth/refresh'

const PUBLIC_WEBAPP_PATH_PREFIXES = [
  '/chat/',
  '/completion/',
  '/workflow/',
]

const isPublicWebAppPath = async () => {
  const requestHeaders = await headers()
  const pathname = requestHeaders.get(CURRENT_PATHNAME_HEADER) || `${basePath}/`

  const normalizedPathname = basePath && pathname.startsWith(basePath)
    ? pathname.slice(basePath.length) || '/'
    : pathname

  return PUBLIC_WEBAPP_PATH_PREFIXES.some(prefix =>
    normalizedPathname.startsWith(prefix),
  )
}
"""

function_marker = """export async function CommonLayoutHydrationBoundary({ children }: { children: ReactNode }) {
  const queryClient = getQueryClientServer()
"""

function_replacement = """export async function CommonLayoutHydrationBoundary({ children }: { children: ReactNode }) {
  // Public WebApp uses its own authentication flow and must not require
  // a Dify Console account session.
  if (await isPublicWebAppPath())
    return <>{children}</>

  const queryClient = getQueryClientServer()
"""

if "PUBLIC_WEBAPP_PATH_PREFIXES" in content:
    print("[SKIP] Patch already applied")
    raise SystemExit(0)

if constant_marker not in content:
    raise SystemExit("[ERROR] Constant insertion marker not found")

if function_marker not in content:
    raise SystemExit("[ERROR] Function insertion marker not found")

content = content.replace(constant_marker, constant_replacement, 1)
content = content.replace(function_marker, function_replacement, 1)

path.write_text(content, encoding="utf-8")
print(f"[WRITE] {path}")
PY

log CHECK "检查补丁内容"

grep -q "const PUBLIC_WEBAPP_PATH_PREFIXES" "$TARGET" \
  || die "补丁校验失败：未找到 PUBLIC_WEBAPP_PATH_PREFIXES"

grep -q "if (await isPublicWebAppPath())" "$TARGET" \
  || die "补丁校验失败：未找到公开路由绕过逻辑"

log OK "Dify 1.15.0 公开访问补丁已应用"

cat <<EOF

后续操作：

1. 查看差异：
   git diff -- '${TARGET_REL}'

2. 重新构建前端镜像。通常在 Dify 源码根目录执行：
   cd '${DIFY_ROOT}'
   docker build -f web/Dockerfile -t dify-web:1.15.0-public-hotfix ./web

   如果 Dockerfile 要求以仓库根目录作为构建上下文，则执行：
   docker build -f web/Dockerfile -t dify-web:1.15.0-public-hotfix .

3. 修改 docker-compose.yaml 中 web 服务：
   image: dify-web:1.15.0-public-hotfix

4. 仅重建 web 容器：
   docker compose up -d --no-deps --force-recreate web

5. 无痕窗口测试：
   /chat/{app_code}
   /completion/{app_code}
   /workflow/{app_code}

回滚：
   cp -a '${BACKUP}' '${TARGET}'
EOF
