#!/usr/bin/env bash
set -Eeuo pipefail

# Dify 1.15.0 public WebApp timestamp hotfix
#
# 功能：
#   1. 为 useTimestamp 增加外部 timezone 参数，避免公开 WebApp 访问时查询 Console Profile。
#   2. 让公开 WebApp chat wrapper 使用浏览器时区并传给 useChat。
#   3. 幂等执行，重复运行不会重复插入。
#
# 使用：
#   ./patch-1.15.0.sh /path/to/dify
#
# 如果当前目录就是 Dify 源码根目录：
#   ./patch-1.15.0.sh
#
# 注意：
#   这是前端源码补丁。执行后必须重新构建 dify-web 镜像并替换 web 容器。

DIFY_ROOT="${1:-$(pwd)}"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"

log() {
  printf '[%s] %s\n' "$1" "$2"
}

die() {
  log ERROR "$1" >&2
  exit 1
}

log INFO "Dify 根目录：$DIFY_ROOT"

python3 - "$DIFY_ROOT" "$TIMESTAMP" <<'PY'
from pathlib import Path
import shutil
import sys

root = Path(sys.argv[1]).resolve()
timestamp = sys.argv[2]

targets = [
    "web/hooks/use-timestamp.ts",
    "web/app/components/base/chat/chat/hooks.ts",
    "web/app/components/base/chat/chat-with-history/chat-wrapper.tsx",
    "web/app/components/base/chat/embedded-chatbot/chat-wrapper.tsx",
]


def log(level: str, message: str) -> None:
    print(f"[{level}] {message}")


def read(rel: str) -> str:
    path = root / rel
    if not path.is_file():
        raise SystemExit(f"[ERROR] 未找到目标文件：{path}")
    return path.read_text(encoding="utf-8")


def write(rel: str, content: str) -> None:
    path = root / rel
    backup = path.with_name(f"{path.name}.bak.public-webapp.{timestamp}")
    if not backup.exists():
        shutil.copy2(path, backup)
        log("BACKUP", f"{path} -> {backup}")
    path.write_text(content, encoding="utf-8")
    log("WRITE", str(path))


def replace_once(content: str, old: str, new: str, rel: str) -> str:
    if old not in content:
        raise SystemExit(f"[ERROR] {rel} 未找到预期代码片段，源码可能不是预期的 Dify 1.15.0")
    return content.replace(old, new, 1)


for rel in targets:
    read(rel)

updates: list[tuple[str, str]] = []

rel = "web/hooks/use-timestamp.ts"
content = read(rel)
if "type UseTimestampOptions" in content:
    log("SKIP", f"{rel} 已包含 timezone 参数")
else:
    content = replace_once(
        content,
        """dayjs.extend(utc)
dayjs.extend(timezone)

const useTimestamp = () => {
  const { data: timezone } = useQuery({
    ...userProfileQueryOptions(),
    select: data => data.profile.timezone ?? undefined,
  })

  const formatTime = useCallback((value: number, format: string) => {
    return dayjs.unix(value).tz(timezone).format(format)
  }, [timezone])

  const formatDate = useCallback((value: string, format: string) => {
    return dayjs(value).tz(timezone).format(format)
  }, [timezone])
""",
        """dayjs.extend(utc)
dayjs.extend(timezone)

type UseTimestampOptions = {
  timezone?: string
}

const getBrowserTimezone = () => {
  return Intl.DateTimeFormat().resolvedOptions().timeZone
}

const useTimestamp = ({ timezone: timezoneOverride }: UseTimestampOptions = {}) => {
  const { data: accountTimezone } = useQuery({
    ...userProfileQueryOptions(),
    select: data => data.profile.timezone ?? undefined,
    enabled: timezoneOverride === undefined,
  })
  const resolvedTimezone = timezoneOverride ?? accountTimezone ?? getBrowserTimezone()

  const formatTime = useCallback((value: number, format: string) => {
    return dayjs.unix(value).tz(resolvedTimezone).format(format)
  }, [resolvedTimezone])

  const formatDate = useCallback((value: string, format: string) => {
    return dayjs(value).tz(resolvedTimezone).format(format)
  }, [resolvedTimezone])
""",
        rel,
    )
    updates.append((rel, content))

rel = "web/app/components/base/chat/chat/hooks.ts"
content = read(rel)
if "type UseChatOptions" in content:
    log("SKIP", f"{rel} 已包含 useChat options")
else:
    content = replace_once(
        content,
        """type SendCallback = {
  onGetConversationMessages?: (conversationId: string, getAbortController: GetAbortController) => Promise<any>
  onGetSuggestedQuestions?: (responseItemId: string, getAbortController: GetAbortController) => Promise<any>
  onConversationComplete?: (conversationId: string) => void
  isPublicAPI?: boolean
}
""",
        """type SendCallback = {
  onGetConversationMessages?: (conversationId: string, getAbortController: GetAbortController) => Promise<any>
  onGetSuggestedQuestions?: (responseItemId: string, getAbortController: GetAbortController) => Promise<any>
  onConversationComplete?: (conversationId: string) => void
  isPublicAPI?: boolean
}

type UseChatOptions = {
  timezone?: string
}
""",
        rel,
    )
    content = replace_once(
        content,
        """  clearChatList?: boolean,
  clearChatListCallback?: (state: boolean) => void,
  initialConversationId?: string,
) => {
  const { t } = useTranslation()
  const { formatTime } = useTimestamp()
""",
        """  clearChatList?: boolean,
  clearChatListCallback?: (state: boolean) => void,
  initialConversationId?: string,
  options: UseChatOptions = {},
) => {
  const { t } = useTranslation()
  const { formatTime } = useTimestamp({ timezone: options.timezone })
""",
        rel,
    )
    updates.append((rel, content))

rel = "web/app/components/base/chat/chat-with-history/chat-wrapper.tsx"
content = read(rel)
if "const timezone = appSourceType === AppSourceType.webApp" in content:
    log("SKIP", f"{rel} 已传递 WebApp timezone")
else:
    content = replace_once(
        content,
        """  const appSourceType = isInstalledApp ? AppSourceType.installedApp : AppSourceType.webApp
""",
        """  const appSourceType = isInstalledApp ? AppSourceType.installedApp : AppSourceType.webApp
  const timezone = appSourceType === AppSourceType.webApp
    ? Intl.DateTimeFormat().resolvedOptions().timeZone
    : undefined
""",
        rel,
    )
    content = replace_once(
        content,
        """    taskId => stopChatMessageResponding('', taskId, appSourceType, appId),
    clearChatList,
    setClearChatList,
  )
""",
        """    taskId => stopChatMessageResponding('', taskId, appSourceType, appId),
    clearChatList,
    setClearChatList,
    undefined,
    { timezone },
  )
""",
        rel,
    )
    updates.append((rel, content))

rel = "web/app/components/base/chat/embedded-chatbot/chat-wrapper.tsx"
content = read(rel)
if "const timezone = appSourceType === AppSourceType.webApp" in content:
    log("SKIP", f"{rel} 已传递 WebApp timezone")
else:
    content = replace_once(
        content,
        """  const sendOnEnter = useMemo(() => {
""",
        """  const timezone = appSourceType === AppSourceType.webApp
    ? Intl.DateTimeFormat().resolvedOptions().timeZone
    : undefined

  const sendOnEnter = useMemo(() => {
""",
        rel,
    )
    content = replace_once(
        content,
        """    taskId => stopChatMessageResponding('', taskId, appSourceType, appId),
    clearChatList,
    setClearChatList,
  )
""",
        """    taskId => stopChatMessageResponding('', taskId, appSourceType, appId),
    clearChatList,
    setClearChatList,
    undefined,
    { timezone },
  )
""",
        rel,
    )
    updates.append((rel, content))

if not updates:
    log("SKIP", "补丁已存在，无需重复执行")
    raise SystemExit(0)

for rel, content in updates:
    write(rel, content)

for rel in targets:
    content = read(rel)
    if rel.endswith("use-timestamp.ts") and "enabled: timezoneOverride === undefined" not in content:
        raise SystemExit(f"[ERROR] {rel} 补丁校验失败")
    if rel.endswith("chat/hooks.ts") and "useTimestamp({ timezone: options.timezone })" not in content:
        raise SystemExit(f"[ERROR] {rel} 补丁校验失败")
    if rel.endswith("chat-wrapper.tsx") and "{ timezone }" not in content:
        raise SystemExit(f"[ERROR] {rel} 补丁校验失败")

log("OK", "Dify 1.15.0 公开 WebApp 时间戳补丁已应用")
PY
