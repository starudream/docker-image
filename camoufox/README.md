# Camoufox

通用独立浏览器镜像，提供官方 Playwright WebSocket 接口与 KasmVNC Web 桌面，业务程序和代理配置由客户端独立管理。

[返回镜像列表](../README.md#镜像列表) · [Dockerfile](./Dockerfile) · [构建工作流](../.github/workflows/camoufox.yml)

> 当前镜像尚未构建成功与发布。下述版本、标签、架构和服务接口均来自源码配置，构建及运行行为尚未验证。

## 镜像与架构

| 项目               | 配置                                   |
|--------------------|----------------------------------------|
| Docker Hub（目标） | `starudream/camoufox`                  |
| GHCR（目标）       | `ghcr.io/starudream/camoufox`          |
| 标签（计划）       | `0.5.8`、`latest`                      |
| 架构（配置）       | `linux/amd64`、`linux/arm64`           |
| 运行用户           | UID/GID `1000:1000`，用户名 `camoufox` |
| 默认工作目录       | `/app`                                 |

## 组件版本

| 组件               | 版本                                   |
|--------------------|----------------------------------------|
| Python 基础镜像    | `3.14.8-slim-bookworm`                 |
| Camoufox Python 包 | `0.5.8`                                |
| Camoufox 浏览器    | `156.0.1-beta.36`，Python 包的配套构建 |
| Playwright         | `1.62.0`                               |
| KasmVNC            | `1.5.0`                                |

构建阶段按架构下载 KasmVNC 和浏览器发布包并检查 SHA-256，同时预置指纹模型。
启动时不安装软件或下载浏览器，默认禁用 GeoIP 查询和 uBlock Origin。

## 使用方式

以下命令用于镜像构建完成后的部署。先在运行环境中设置 `KASMVNC_PASSWORD`，再启动容器。
密码不应写入镜像、命令行字面量或提交到仓库。

```bash
docker run -d --name camoufox \
  --shm-size=1g \
  -p 127.0.0.1:3000:3000 \
  -p 127.0.0.1:8443:8443 \
  -e KASMVNC_PASSWORD \
  starudream/camoufox:0.5.8
```

使用 GHCR 时，将镜像地址替换为 `ghcr.io/starudream/camoufox:0.5.8`。

### 服务接口

| 接口       | 默认地址                 | 说明                                                             |
|------------|--------------------------|------------------------------------------------------------------|
| Playwright | `ws://127.0.0.1:3000/ws` | 使用 Firefox Connect，客户端 Playwright 主、次版本须与服务端一致 |
| Web 桌面   | `https://127.0.0.1:8443` | 用户名为 `camoufox`，密码来自 `KASMVNC_PASSWORD`                 |

Playwright 端口可完全控制浏览器，KasmVNC 登录认证不保护该独立端口，因此只应向可信客户端开放。
示例将两个端口绑定在宿主机回环地址；同一 Docker 网络中的客户端可以使用 `ws://camoufox:3000/ws`，无需发布 Playwright 端口。

浏览器在虚拟显示器中以有界面模式运行，服务器无需物理显示器。
容器不自动创建默认浏览窗口；客户端创建上下文和页面后，才会在 Web 桌面中显示对应窗口。

### Web 桌面与证书

KasmVNC 提供自己的 Web 客户端，不依赖 noVNC 或 websockify，也不支持传统 VNC viewer。
启动时生成的自签名证书用于 Web 桌面的 HTTPS / WSS 连接，首次访问时需要接受该证书。
该证书与被访问网站的证书及上下文代理无关。

| 路径                          | 内容              |
|-------------------------------|-------------------|
| `/home/camoufox/.vnc/tls.crt` | Web 桌面 TLS 证书 |
| `/home/camoufox/.vnc/tls.key` | Web 桌面 TLS 私钥 |

证书或私钥缺失时会重新生成，同一容器重启时复用，重建容器后默认重新生成。

## 环境配置

| 环境变量           | 默认值    | 用途与约束                                                      |
|--------------------|-----------|-----------------------------------------------------------------|
| `LANG`             | `C.UTF-8` | UTF-8 字符环境，用于压缩包文件名及桌面文本处理                  |
| `KASMVNC_PASSWORD` | 必填      | Web 桌面密码，至少 6 个字符，不能含换行；不传给浏览器子进程     |
| `DISPLAY_WIDTH`    | `1920`    | 虚拟屏幕宽度，须为正整数                                        |
| `DISPLAY_HEIGHT`   | `1080`    | 虚拟屏幕高度，须为正整数                                        |
| `CAMOUFOX_HOST`    | `0.0.0.0` | Playwright 监听地址                                             |
| `CAMOUFOX_PORT`    | `3000`    | Playwright 监听端口，范围为 1–65535；修改时同步调整容器端口映射 |
| `CAMOUFOX_WS_PATH` | `ws`      | Playwright WebSocket 路径，不能为空，不能用作认证机制           |

Playwright `launchServer()` 未指定端口时使用随机可用端口，本镜像采用官方远程容器示例中的 `3000`。
KasmVNC 默认按 `8443 + 显示器编号` 选择端口，当前使用 `DISPLAY=:0.0` 和端口 `8443`。

### 中文显示

镜像设置 `LANG=C.UTF-8`，并安装 Fontconfig 与 `fonts-noto-cjk`，在构建阶段生成系统字体缓存。
Noto CJK 包含简体中文和繁体中文字体，为 Fluxbox 桌面的窗口标题、菜单及使用系统字体的应用提供中文字形。

Camoufox 浏览器通过独立的 Fontconfig 配置和字体列表使用捆绑字体；安装系统字体不等于网页会自动使用这些字体。
镜像保留上游的字体选择机制，不将所有系统字体强制注入浏览器。网页中文和桌面中文的实际显示效果均需在构建后验证。

字体与输入法独立，镜像未安装中文输入法；`C.UTF-8` 也不表示桌面或浏览器界面会切换为中文。

## Playwright 客户端

### 版本与连接

远程协议要求客户端与服务端的 Playwright 主、次版本一致，允许补丁版本不同，因此 Go 客户端应使用 Playwright `1.62.x`。
例如，`github.com/mxschmitt/playwright-go v0.6201.1` 配套驱动为 `1.62.1`，服务端 Python 包为 `1.62.0`。
客户端驱动仍须与所用 Go SDK 配套，不能直接套用 Python 包版本号。

远程模式需要在客户端准备驱动及 Node.js，无需安装浏览器。调用顺序如下：

```text
playwright.Run(SkipInstallBrowsers=true)
  → pw.Firefox.Connect(endpoint)
  → remoteBrowser.NewContext(options)
  → context.NewPage()
```

### 上下文与代理

各客户端独立管理自己的上下文，不自动共享登录状态。
代理、StorageState 和其他上下文选项由客户端传入，以下为接口片段：

```go
options := playwright.BrowserNewContextOptions{
	NoViewport:        playwright.Bool(true),
	IgnoreHttpsErrors: playwright.Bool(true),
}
if proxyServer != "" {
	options.Proxy = &playwright.Proxy{Server: proxyServer}
}
if hasSavedState {
	options.StorageStatePath = playwright.String(statePath)
}
context, err := remoteBrowser.NewContext(options)
```

代理由浏览器容器连接，因此代理地址必须从浏览器所在网络可达；未指定代理的上下文不依赖其他客户端的代理。
`IgnoreHttpsErrors` 按客户端需要设置，不要求所有客户端启用。

上下文代理不会自动重新生成浏览器启动阶段的指纹、GeoIP 或 WebRTC 信息；有出口一致性要求时由客户端设计和验证对应公开接口，镜像不绑定某个业务出口。

### 登录状态与生命周期

Go 创建的页面可在 KasmVNC 中操作，手动登录应在客户端自己的上下文内进行。
登录后由客户端调用 `StorageState()`，按需启用 `IndexedDB`，并将快照保存到客户端持久化目录。
重建上下文时重新传入代理和快照。

官方远程服务不支持完整的持久化用户目录。
StorageState 不包含 Session Storage、扩展状态、页面或完整浏览器配置；浏览器容器无需共享客户端快照目录，浏览器安装缓存也不应作为登录数据目录。

客户端退出时只关闭自己的上下文并断开连接，浏览器服务由容器独立管理。
连接或服务中断后，需要重新创建上下文和页面，不能继续使用旧远程对象。

## 运行与恢复

浏览器服务启动前，先等待 KasmVNC 显示器就绪，最多等待 30 秒。
启动包装每 5 秒直接检查本地 Playwright `/json` 端点，不经过环境代理。

| 阶段                 | 恢复条件与行为                                                          |
|----------------------|-------------------------------------------------------------------------|
| 首次启动             | 最多约 120 秒内就绪，否则退出并交由 Supervisor 重启                     |
| 正常运行             | 连续 3 次检查失败时，通知官方包装回收子进程，再退出并由 Supervisor 重启 |
| 浏览器或显示服务异常 | 端点失效后进入同一恢复流程，已有页面和连接不会自动恢复                  |

## 构建与更新

[Camoufox 工作流](../.github/workflows/camoufox.yml) 仅在 `master` 分支构建和发布。
修改 `camoufox/` 或工作流文件会触发构建，也可手动触发；未配置每日构建。

在仓库根目录中执行以下命令，可构建 `linux/amd64` 镜像：

```bash
docker buildx build \
  --platform linux/amd64 \
  --load \
  -t starudream/camoufox:0.5.8 \
  camoufox
```

升级时应一并核对 Camoufox Python 包、配套浏览器、SHA-256 校验值、Playwright 版本与工作流标签。
浏览器升级若改变 Playwright 主、次版本，客户端需要同步升级。

### 离线交付

构建完成并核对本地镜像架构后，可导出离线归档：

```bash
docker save \
  -o camoufox-0.5.8-linux-amd64.tar \
  starudream/camoufox:0.5.8
```

arm64 交付时将构建平台改为 `linux/arm64`，并使用对应归档文件名。
固定镜像 digest 或记录归档校验值，以明确现场使用的版本；浏览器镜像交付后，业务程序可以独立更新。

双架构构建、Web 桌面、中文显示与输入、登录快照恢复、客户端连接及故障恢复均待目标环境验证，静态检查不能替代这些运行验证。

## 参考资料

- [Playwright 官方远程容器示例](https://github.com/microsoft/playwright/blob/v1.62.0/docs/src/docker.md#remote-connection)
- [KasmVNC 默认端口规则](https://github.com/kasmtech/KasmVNC/blob/v1.5.0/unix/vncserver#L2675)
