# Camoufox

通用独立浏览器镜像，提供官方 Playwright WebSocket 接口和 KasmVNC Web 桌面。镜像不包含业务程序，不读取业务配置，不依赖业务代理。

## 版本与架构

| 组件               | 版本                                      |
|--------------------|-------------------------------------------|
| Python 基础镜像    | `3.14.8-slim-bookworm`                    |
| Camoufox Python 包 | `0.5.8`                                   |
| Camoufox 浏览器    | `156.0.1-beta.36`，该 Python 包的配套构建 |
| Playwright         | `1.62.0`                                  |
| KasmVNC            | `1.5.0`                                   |

构建支持 `linux/amd64` 和 `linux/arm64`。KasmVNC 和浏览器发布包按架构下载并检查 SHA-256；指纹模型在构建阶段预置。启动时不安装软件或下载浏览器，默认禁用 GeoIP 查询和 uBlock Origin。

镜像标签为 `starudream/camoufox:0.5.8`、`starudream/camoufox:latest`，GHCR 提供同名镜像 `ghcr.io/starudream/camoufox`。升级时一起核对 Python 包、配套浏览器、校验值、Playwright 及 workflow 标签。

## 启动

先在运行环境设置 `KASMVNC_PASSWORD`，再启动容器。该值不应写入镜像、命令行字面量或提交到仓库。

```bash
docker run -d --name camoufox \
  --shm-size=1g \
  -p 127.0.0.1:3000:3000 \
  -p 127.0.0.1:8443:8443 \
  -e KASMVNC_PASSWORD \
  starudream/camoufox:0.5.8
```

| 接口       | 地址                     | 说明                                                             |
|------------|--------------------------|------------------------------------------------------------------|
| Playwright | `ws://127.0.0.1:3000/ws` | 使用 Firefox Connect，客户端 Playwright 主、次版本应与服务端一致 |
| Web 桌面   | `https://127.0.0.1:8443` | 用户名 `camoufox`，密码来自 `KASMVNC_PASSWORD`                   |

KasmVNC 使用容器启动时生成的自签名证书，为 Web 桌面的 HTTPS / WSS 连接提供 TLS 加密，与被访问网站的证书及上下文代理无关。

证书与私钥分别位于容器的 `/home/camoufox/.vnc/tls.crt`、`/home/camoufox/.vnc/tls.key`；仅在文件缺失时生成，同一容器重启会复用，重建容器后默认重新生成。

浏览器首次访问需要接受该证书。它提供自己的 Web 客户端，不再使用 noVNC 或 websockify，也不支持传统 VNC viewer。镜像以 UID/GID `1000:1000` 运行。

Playwright 端口可完全控制浏览器，KasmVNC 的登录认证不保护这个独立端口；只对可信客户端开放，默认示例将两个端口绑定在宿主机回环地址。同一 Docker 网络中的客户端可直接使用 `ws://camoufox:3000/ws`，无需发布
Playwright 端口。

## 配置

| 环境变量           | 默认值    | 用途                                                          |
|--------------------|-----------|---------------------------------------------------------------|
| `KASMVNC_PASSWORD` | 必填      | Web 桌面密码，至少 6 个字符，不能含换行；不会传给浏览器子进程 |
| `DISPLAY_WIDTH`    | `1920`    | 虚拟屏幕宽度                                                  |
| `DISPLAY_HEIGHT`   | `1080`    | 虚拟屏幕高度                                                  |
| `CAMOUFOX_HOST`    | `0.0.0.0` | Playwright 监听地址                                           |
| `CAMOUFOX_PORT`    | `3000`    | Playwright 监听端口；修改后需同步容器端口映射                 |
| `CAMOUFOX_WS_PATH` | `ws`      | Playwright WebSocket 路径，不能当作认证机制                   |

Playwright `launchServer()` 未指定端口时使用随机可用端口，本镜像采用官方容器部署示例中的 `3000` 作为固定端口。KasmVNC 默认按 `8443 + 显示器编号` 选择端口，当前 `DISPLAY=:0.0` 对应 `8443`
。浏览器使用有界面模式在虚拟显示器运行，服务器无需物理显示器。

参考：[Playwright 官方远程容器示例](https://github.com/microsoft/playwright/blob/v1.62.0/docs/src/docker.md#remote-connection)、[KasmVNC 默认端口规则](https://github.com/kasmtech/KasmVNC/blob/v1.5.0/unix/vncserver#L2675)。

容器不自动创建默认浏览窗口。客户端创建的上下文和页面才会显示在 Web 桌面中；还没有客户端连接时，桌面可能没有浏览器窗口。客户端之间分别管理自己的上下文，不自动共享登录状态。

## Playwright 客户端

Go 客户端使用 Playwright `1.62.x`，例如 `github.com/mxschmitt/playwright-go v0.6201.1` 配套的驱动为 `1.62.1`，服务端 Python 包为 `1.62.0`。官方远程协议要求主、次版本一致，允许补丁版本不同；客户端驱动仍须与所用
Go SDK 配套，不能直接套用 Python 包版本号。远程模式仍需在客户端准备驱动及 Node.js，但不需要安装浏览器。

调用顺序为：

```text
playwright.Run(SkipInstallBrowsers=true)
  → pw.Firefox.Connect(endpoint)
  → remoteBrowser.NewContext(options)
  → context.NewPage()
```

代理、StorageState 和上下文选项由客户端传入。以下为接口片段：

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

代理地址由浏览器容器连接，应使用从浏览器所在网络实际可达的地址。未指定代理的上下文不依赖其他客户端的代理。`IgnoreHttpsErrors` 按客户端需要设置，不要求所有客户端启用。

上下文代理不会自动重新生成浏览器启动阶段的指纹、GeoIP 或 WebRTC 信息；有出口一致性要求时由客户端设计和验证对应公开接口，镜像不绑定某个业务出口。

Go 创建的页面可在 KasmVNC 中操作，手动登录必须在客户端自己的上下文内进行。登录后由客户端调用 `StorageState()`，按需启用 `IndexedDB`，并将快照保存到客户端持久化目录。重建上下文时重新传入代理和快照。

官方远程服务不支持完整的持久化用户目录；StorageState 不包含 Session Storage、扩展状态、页面或完整浏览器配置。浏览器容器无需共享客户端快照目录，也不要把浏览器安装缓存当作登录数据目录。

客户端退出时只关闭自己的上下文并断开连接，浏览器服务由容器独立管理。连接或服务中断后重新创建上下文和页面，不能继续使用旧远程对象。

浏览器启动包装每 5 秒直接检查本地 Playwright `/json` 端点，不经过环境代理。首次启动允许最多约 120 秒就绪；就绪后连续 3 次检查失败时，主线程通知官方包装关闭子进程，再退出交由 Supervisor 重启。浏览器崩溃、被退出或显示服务重启造成端点失效时使用同一恢复流程，已有页面和连接不会自动恢复。

## 构建与离线交付

GitHub Actions workflow 为 `.github/workflows/camoufox.yml`，同时构建和发布两种架构的镜像。以下命令仅为使用说明，编写本镜像时没有执行构建或启动验证。

```bash
docker buildx build --platform linux/amd64 --load -t starudream/camoufox:0.5.8 camoufox
docker save -o camoufox-0.5.8-linux-amd64.tar starudream/camoufox:0.5.8
```

arm64 交付时将构建平台改为 `linux/arm64` 并使用对应归档文件名；只在构建完成并核对本地镜像架构后导出，不把本机已有镜像直接当作另一个架构的制品。

浏览器镜像首次交付后，业务程序独立更新。浏览器升级若改变 Playwright 版本，需要客户端同步升级。固定镜像 digest 或记录归档校验值，以明确离线现场实际使用的版本。

当前声明的双架构构建能力基于上游发布包和 Dockerfile 映射；两个架构的实际构建、Web 桌面、中文输入、登录快照恢复和客户端连接均需要另行授权后验证，静态检查不能替代这些验证。
