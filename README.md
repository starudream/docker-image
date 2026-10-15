# Docker Image

![license](https://img.shields.io/github/license/starudream/docker-image?style=for-the-badge)

## Status

| Workflow | Status                                                                                                                    | Size                                                                                                                                                                                                                      |
|----------|---------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| alpine   | ![status](https://img.shields.io/github/actions/workflow/status/starudream/docker-image/alpine.yml?style=for-the-badge)   | ![size](https://img.shields.io/docker/image-size/starudream/alpine?style=for-the-badge&label=alpine)<br/>![size](https://img.shields.io/docker/image-size/starudream/alpine-glibc?style=for-the-badge&label=alpine-glibc) |
| golang   | ![status](https://img.shields.io/github/actions/workflow/status/starudream/docker-image/golang.yml?style=for-the-badge)   | ![size](https://img.shields.io/docker/image-size/starudream/golang?style=for-the-badge&label=golang)<br/>![size](https://img.shields.io/docker/image-size/starudream/golang-devel?style=for-the-badge&label=golang-devel) |
| clash    | ![status](https://img.shields.io/github/actions/workflow/status/starudream/docker-image/clash.yml?style=for-the-badge)    | ![size](https://img.shields.io/docker/image-size/starudream/clash?style=for-the-badge&label=clash)                                                                                                                        |
| camoufox | ![status](https://img.shields.io/github/actions/workflow/status/starudream/docker-image/camoufox.yml?style=for-the-badge) | ![size](https://img.shields.io/docker/image-size/starudream/camoufox?style=for-the-badge&label=camoufox)                                                                                                                  |

所有镜像仅从 `master` 分支构建和发布，修改对应镜像目录或工作流文件时自动触发，也可手动触发。Alpine 系列（`alpine`、`alpine-glibc`）和 Golang 系列（`golang`、`golang-devel`）
每天北京时间 04:00 （UTC 20:00）执行一次不使用层缓存的构建，先构建基础镜像，再构建派生镜像。定时构建要求仓库默认分支为 `master`，实际启动时间可能受 GitHub Actions 调度影响而延迟。

## Camoufox

[独立浏览器镜像](./camoufox/README.md)：支持 `linux/amd64`、`linux/arm64`，提供官方 Playwright 接口与 KasmVNC Web 桌面。

## [License](./LICENSE)
