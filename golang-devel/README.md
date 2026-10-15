# Golang Devel

基于 `starudream/golang` 的 Go 开发与 CI 镜像，预装构建、代码生成、静态检查及发布工具。

[返回镜像列表](../README.md#镜像列表) · [Dockerfile](./Dockerfile) · [工具安装脚本](./init.sh) · [构建工作流](../.github/workflows/golang.yml)

## 镜像与架构

| 项目         | 配置                                                                |
|--------------|---------------------------------------------------------------------|
| Docker Hub   | `starudream/golang-devel:latest`                                    |
| GHCR         | `ghcr.io/starudream/golang-devel:latest`                            |
| 架构         | `linux/amd64`                                                       |
| 基础镜像     | `starudream/golang:latest`，仓库当前定义为 Go 1.27 / Alpine 3.24    |
| 默认工作目录 | `/go`，继承自官方 Go 基础镜像                                       |
| 每日构建     | 北京时间 04:00（UTC 20:00），先构建 `golang`，再构建 `golang-devel` |

工具安装脚本下载的发布包固定使用 `amd64` / `x86_64` 架构，因此该镜像当前仅构建 `linux/amd64`。

## 环境配置

镜像继承 Go 基础镜像的配置：

| 配置          | 值                                             |
|---------------|------------------------------------------------|
| 时区          | `/etc/localtime` 使用 `Asia/Shanghai`          |
| `CGO_ENABLED` | `0`                                            |
| `GO111MODULE` | `on`                                           |
| `GOPROXY`     | `https://goproxy.cn,https://goproxy.io,direct` |
| APK 软件源    | 华为云 Alpine 镜像源                           |

Go 配置由基础镜像通过 `go env -w` 写入，可以通过环境变量覆盖。
镜像预装 CA 证书、时区数据、Bash、Make、Git、UPX、curl、unzip、jq、OpenSSH 和 rsync。

## 预装工具

### 发布包工具

这些工具在构建时下载，其版本记录在 `/usr/local/bin/.ver/`。

| 命令            | 用途                    | 构建时版本来源    |
|-----------------|-------------------------|-------------------|
| `docker`        | Docker CLI              | Moby 最新 Release |
| `kubectl`       | Kubernetes CLI          | 官方 `stable.txt` |
| `goreleaser`    | Go 项目打包与发布       | 最新 Release      |
| `golangci-lint` | Go 静态检查             | 最新 Release      |
| `protoc`        | Protocol Buffers 编译器 | 最新 Release      |
| `buf`           | Protocol Buffers 工具链 | 最新 Release      |
| `sqlc`          | 从 SQL 生成类型安全代码 | 最新 Release      |

镜像只安装 Docker CLI，不包含 Docker daemon；使用 Docker 命令时需要连接可用的 daemon。

### Go 安装工具

以下 14 个工具由 `go install <module>@latest` 安装，统一使用 `CGO_ENABLED=0`。

| 命令                      | 用途                                |
|---------------------------|-------------------------------------|
| `godoc`                   | Go 文档服务                         |
| `goimports`               | 格式化 Go 代码并整理导入            |
| `stringer`                | 生成枚举类型的字符串方法            |
| `gci`                     | 按规则整理 Go 导入分组              |
| `protoc-gen-go`           | 生成 Protocol Buffers Go 类型       |
| `protoc-gen-go-grpc`      | 生成 gRPC Go 服务代码               |
| `protoc-gen-grpc-gateway` | 生成 gRPC Gateway 代码              |
| `protoc-gen-openapiv2`    | 生成 OpenAPI v2 定义                |
| `protoc-gen-go-json`      | 生成 Protocol Buffers JSON 辅助代码 |
| `protoc-go-inject-tag`    | 为生成的 Go 结构体注入标签          |
| `gotestsum`               | Go 测试执行与报告                   |
| `ent`                     | Ent 代码生成工具                    |
| `gorm`                    | GORM CLI 代码生成工具               |
| `wails`                   | Wails v2 命令行工具                 |

gotestsum 统一从 `gotest.tools/gotestsum` 安装，不再同时下载同名发布包。

### 使用边界

- **项目版本**：镜像预装工具使用构建时的最新版本；项目固定的插件版本仍以项目自身的安装命令为准。
- **Wails**：仅提供 CLI，未安装 Node.js、GTK、WebKit 和桌面构建环境；完整应用构建仍需对应平台的依赖。
- **CGO 与 race**：项目若需要编译 CGO 代码或使用 `-race`，需自行准备 C 编译工具链并显式启用 CGO。

### 安装路径与版本记录

| 路径                                  | 内容                                                                          |
|---------------------------------------|-------------------------------------------------------------------------------|
| `/usr/local/bin/`                     | 发布包工具，位于 `PATH` 中                                                    |
| `/usr/local/bin/.ver/`                | 7 个发布包工具的版本记录，以及 Go 安装工具的构建信息，文件名与命令名一致      |
| `/go/bin/`                            | `go install` 安装的工具，位于 `PATH` 中                                       |
| `/usr/local/include/google/protobuf/` | protoc 标准定义，包含 `timestamp.proto`、`empty.proto`、`descriptor.proto` 等 |

protoc 会自动搜索 `/usr/local/include`，项目导入标准定义时无需再复制这些文件。
Go 安装工具的记录来自 `go version -m`，包含主模块、依赖版本和构建设置；该操作只读取二进制元数据，不运行工具。
例如，`/usr/local/bin/.ver/gotestsum` 记录 gotestsum 的构建信息。

## 使用方式

在项目目录中启动交互式开发环境：

```bash
docker run --rm -it \
  -v "$PWD":/workspace \
  -w /workspace \
  starudream/golang-devel:latest bash
```

也可直接执行构建命令：

```bash
docker run --rm \
  -v "$PWD":/workspace \
  -w /workspace \
  starudream/golang-devel:latest go build ./...
```

使用 GHCR 时，将镜像地址替换为 `ghcr.io/starudream/golang-devel:latest`。

## 构建与更新

[Golang 工作流](../.github/workflows/golang.yml) 仅在 `master` 分支构建和发布。
修改 `golang/`、`golang-devel/` 或工作流文件会触发构建，也可手动触发。
每日构建禁用层缓存，以更新系统包和工具；其他触发方式使用构建缓存。

在仓库根目录中执行以下命令，可基于已发布的 `starudream/golang` 镜像构建：

```bash
docker build --pull -t starudream/golang-devel:latest golang-devel
```

工具版本在构建时选择，不会在容器启动时自动更新。
`latest` 标签的内容随构建变化，需要固定 CI 或交付环境时应使用镜像 digest，并保留对应工具的版本信息。
