# Docker Image

[![许可证][license-badge]](./LICENSE)
[![最后提交][updated-badge]](https://github.com/starudream/docker-image/commits/master)

用于基础运行环境、Go 开发、代理服务和远程浏览器的 Docker 镜像集合，通过 GitHub Actions 管理构建与发布，目标仓库为 Docker Hub 与 GHCR。

## 镜像列表

| 镜像                                      | 用途                                                | 标签                      | Linux 架构                        | Docker Hub 统计                                               |
|-------------------------------------------|-----------------------------------------------------|---------------------------|-----------------------------------|---------------------------------------------------------------|
| [alpine](./alpine/Dockerfile)             | Alpine 3.24，预装 CA 证书与时区数据                 | `latest`                  | ![amd64 / arm64][multiarch-badge] | ![体积][alpine-size]<br>![拉取次数][alpine-pulls]             |
| [alpine-glibc](./alpine-glibc/Dockerfile) | 基于 Alpine，增加 `gcompat` 与 UPX                  | `latest`                  | ![amd64 / arm64][multiarch-badge] | ![体积][alpine-glibc-size]<br>![拉取次数][alpine-glibc-pulls] |
| [golang](./golang/Dockerfile)             | Go 1.27 / Alpine 3.24，预装常用构建工具             | `latest`                  | ![amd64 / arm64][multiarch-badge] | ![体积][golang-size]<br>![拉取次数][golang-pulls]             |
| [golang-devel](./golang-devel/README.md)  | Go 开发与 CI 工具集，包含代码生成、检查及发布工具   | `latest`                  | ![amd64][amd64-badge]             | ![体积][golang-devel-size]<br>![拉取次数][golang-devel-pulls] |
| [clash](./clash/Dockerfile)               | Mihomo 代理内核，附带 Zashboard 与 GeoIP 数据       | `latest`                  | ![amd64 / arm64][multiarch-badge] | ![体积][clash-size]<br>![拉取次数][clash-pulls]               |
| [camoufox](./camoufox/README.md)          | 独立浏览器，提供 Playwright 接口与 KasmVNC Web 桌面 | `0.5.8`、`latest`（计划） | ![amd64 / arm64][multiarch-badge] | 待首次构建与发布                                              |

架构以工作流的构建配置为准；体积徽章展示 Docker Hub 上 `latest` 标签的 `amd64` 镜像体积，拉取次数为各镜像仓库的累计值。
`alpine-glibc` 使用 `gcompat` 提供兼容能力，不包含完整的 glibc 发行环境。

Camoufox 尚未进行镜像构建，表中的标签与架构为配置目标，启动及客户端连接等运行行为尚未验证。

## 拉取镜像

[![Docker Hub][docker-hub-badge]](https://hub.docker.com/u/starudream)
[![GHCR][ghcr-badge]](https://github.com/starudream?tab=packages)

两个仓库使用相同的镜像名称与标签：

```text
Docker Hub  starudream/<镜像>:<标签>
GHCR        ghcr.io/starudream/<镜像>:<标签>
```

例如，拉取 Go 开发镜像：

```bash
docker pull starudream/golang-devel:latest
```

也可从 GHCR 拉取：

```bash
docker pull ghcr.io/starudream/golang-devel:latest
```

各镜像的 `latest` 标签随构建更新，需要固定交付内容时使用镜像 digest。
Camoufox 的启动参数、客户端版本与连接方式见[使用文档](./camoufox/README.md)。

## 构建策略

| 工作流                                       | master 分支状态                                                                                                                    | 构建镜像                  | 每日构建（北京时间） |
|----------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------|---------------------------|----------------------|
| [Alpine](./.github/workflows/alpine.yml)     | [![Alpine 构建状态][alpine-status]](https://github.com/starudream/docker-image/actions/workflows/alpine.yml?query=branch%3Amaster) | `alpine` → `alpine-glibc` | 04:00                |
| [Golang](./.github/workflows/golang.yml)     | [![Golang 构建状态][golang-status]](https://github.com/starudream/docker-image/actions/workflows/golang.yml?query=branch%3Amaster) | `golang` → `golang-devel` | 04:00                |
| [Clash](./.github/workflows/clash.yml)       | [![Clash 构建状态][clash-status]](https://github.com/starudream/docker-image/actions/workflows/clash.yml?query=branch%3Amaster)    | `clash`                   | —                    |
| [Camoufox](./.github/workflows/camoufox.yml) | [![尚未构建][pending-badge]](https://github.com/starudream/docker-image/actions/workflows/camoufox.yml?query=branch%3Amaster)      | `camoufox`                | —                    |

- **分支**：所有构建与发布仅在 `master` 分支执行，手动触发也受此限制。
- **变更触发**：向 `master` 推送对应镜像目录或工作流文件的变更时，自动构建对应系列；也可在 GitHub Actions 中手动触发。
- **每日构建**：Alpine、Golang 系列每天北京时间 04:00（UTC 20:00）触发，要求仓库默认分支为 `master`；实际启动时间可能受调度影响而延迟。
- **缓存**：每日构建禁用层缓存，重新获取系统包与开发工具；变更及手动触发使用 GitHub Actions 构建缓存。构建均启用基础镜像拉取。
- **顺序**：Alpine、Golang 系列先完成基础镜像的构建与发布，再构建对应派生镜像。

## 详细文档

- [Golang 开发镜像](./golang-devel/README.md)：预装工具、环境配置、版本记录和使用方式。
- [Camoufox 浏览器镜像](./camoufox/README.md)：版本、Web 桌面、Playwright 客户端与离线交付。

## 许可证

[Apache License 2.0](./LICENSE)

[license-badge]: https://img.shields.io/github/license/starudream/docker-image?style=flat-square
[updated-badge]: https://img.shields.io/github/last-commit/starudream/docker-image/master?style=flat-square&label=updated
[multiarch-badge]: https://img.shields.io/badge/linux-amd64%20%7C%20arm64-0078D4?style=flat-square
[amd64-badge]: https://img.shields.io/badge/linux-amd64-0078D4?style=flat-square
[docker-hub-badge]: https://img.shields.io/badge/Docker_Hub-starudream-2496ED?style=flat-square&logo=docker&logoColor=white
[ghcr-badge]: https://img.shields.io/badge/GHCR-starudream-181717?style=flat-square&logo=github&logoColor=white
[alpine-size]: https://img.shields.io/docker/image-size/starudream/alpine/latest?arch=amd64&style=flat-square&label=size
[alpine-pulls]: https://img.shields.io/docker/pulls/starudream/alpine?style=flat-square&label=pulls
[alpine-glibc-size]: https://img.shields.io/docker/image-size/starudream/alpine-glibc/latest?arch=amd64&style=flat-square&label=size
[alpine-glibc-pulls]: https://img.shields.io/docker/pulls/starudream/alpine-glibc?style=flat-square&label=pulls
[golang-size]: https://img.shields.io/docker/image-size/starudream/golang/latest?arch=amd64&style=flat-square&label=size
[golang-pulls]: https://img.shields.io/docker/pulls/starudream/golang?style=flat-square&label=pulls
[golang-devel-size]: https://img.shields.io/docker/image-size/starudream/golang-devel/latest?arch=amd64&style=flat-square&label=size
[golang-devel-pulls]: https://img.shields.io/docker/pulls/starudream/golang-devel?style=flat-square&label=pulls
[clash-size]: https://img.shields.io/docker/image-size/starudream/clash/latest?arch=amd64&style=flat-square&label=size
[clash-pulls]: https://img.shields.io/docker/pulls/starudream/clash?style=flat-square&label=pulls
[alpine-status]: https://img.shields.io/github/actions/workflow/status/starudream/docker-image/alpine.yml?branch=master&style=flat-square&label=build
[golang-status]: https://img.shields.io/github/actions/workflow/status/starudream/docker-image/golang.yml?branch=master&style=flat-square&label=build
[clash-status]: https://img.shields.io/github/actions/workflow/status/starudream/docker-image/clash.yml?branch=master&style=flat-square&label=build
[pending-badge]: https://img.shields.io/badge/build-not_built-lightgrey?style=flat-square
