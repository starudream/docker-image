#!/usr/bin/env bash

set -e

CUR_DIR=/go
cd "$CUR_DIR"

rm -rf "$CUR_DIR"/.tmp && mkdir -p "$CUR_DIR"/.tmp
rm -rf "$CUR_DIR"/.bin && mkdir -p "$CUR_DIR"/.bin
rm -rf "$CUR_DIR"/.ver && mkdir -p "$CUR_DIR"/.ver

# https://github.com/moby/moby/releases
echo "-> docker"
DOCKER_VERSION=$(curl -s https://api.github.com/repos/moby/moby/releases/latest | jq -r '.tag_name')
echo "$DOCKER_VERSION" >"$CUR_DIR"/.ver/docker
wget -qO "$CUR_DIR"/.tmp/docker.tar.gz https://download.docker.com/linux/static/stable/x86_64/docker-"${DOCKER_VERSION#v}".tgz
tar -xzf "$CUR_DIR"/.tmp/docker.tar.gz -C "$CUR_DIR"/.tmp
cp -rf "$CUR_DIR"/.tmp/docker/docker "$CUR_DIR"/.bin/

# https://github.com/kubernetes/kubernetes/releases
echo "-> kubectl"
KUBECTL_VERSION=$(curl -sL https://dl.k8s.io/release/stable.txt)
echo "$KUBECTL_VERSION" >"$CUR_DIR"/.ver/kubectl
wget -qO "$CUR_DIR"/.bin/kubectl https://dl.k8s.io/release/"$KUBECTL_VERSION"/bin/linux/amd64/kubectl

# https://github.com/goreleaser/goreleaser/releases
echo "-> goreleaser"
GORELEASER_VERSION=$(curl -s https://api.github.com/repos/goreleaser/goreleaser/releases/latest | jq -r '.tag_name')
echo "$GORELEASER_VERSION" >"$CUR_DIR"/.ver/goreleaser
wget -qO "$CUR_DIR"/.tmp/goreleaser.tar.gz https://github.com/goreleaser/goreleaser/releases/download/"$GORELEASER_VERSION"/goreleaser_Linux_x86_64.tar.gz
tar -xzf "$CUR_DIR"/.tmp/goreleaser.tar.gz -C "$CUR_DIR"/.tmp
cp -rf "$CUR_DIR"/.tmp/goreleaser "$CUR_DIR"/.bin/

# https://github.com/golangci/golangci-lint/releases
echo "-> golangci-lint"
GOLANGCI_LINT_VERSION=$(curl -s https://api.github.com/repos/golangci/golangci-lint/releases/latest | jq -r '.tag_name')
echo "$GOLANGCI_LINT_VERSION" >"$CUR_DIR"/.ver/golangci-lint
wget -qO "$CUR_DIR"/.tmp/golangci-lint.tar.gz https://github.com/golangci/golangci-lint/releases/download/"$GOLANGCI_LINT_VERSION"/golangci-lint-"${GOLANGCI_LINT_VERSION#v}"-linux-amd64.tar.gz
tar -xzf "$CUR_DIR"/.tmp/golangci-lint.tar.gz -C "$CUR_DIR"/.tmp
cp -rf "$CUR_DIR"/.tmp/golangci-lint-"${GOLANGCI_LINT_VERSION#v}"-linux-amd64/golangci-lint "$CUR_DIR"/.bin/

# https://github.com/protocolbuffers/protobuf/releases
echo "-> protoc"
PROTOC_VERSION=$(curl -s https://api.github.com/repos/protocolbuffers/protobuf/releases/latest | jq -r '.tag_name')
echo "$PROTOC_VERSION" >"$CUR_DIR"/.ver/protoc
wget -qO "$CUR_DIR"/.tmp/protoc.zip https://github.com/protocolbuffers/protobuf/releases/download/"$PROTOC_VERSION"/protoc-"${PROTOC_VERSION#v}"-linux-x86_64.zip
unzip -q "$CUR_DIR"/.tmp/protoc.zip -d "$CUR_DIR"/.tmp
cp -rf "$CUR_DIR"/.tmp/bin/protoc "$CUR_DIR"/.bin/

# https://github.com/bufbuild/buf/releases
echo "-> buf"
BUF_VERSION=$(curl -s https://api.github.com/repos/bufbuild/buf/releases/latest | jq -r '.tag_name')
echo "$BUF_VERSION" >"$CUR_DIR"/.ver/buf
wget -qO "$CUR_DIR"/.bin/buf https://github.com/bufbuild/buf/releases/download/"$BUF_VERSION"/buf-Linux-x86_64

# https://github.com/sqlc-dev/sqlc/releases
echo "-> sqlc"
SQLC_VERSION=$(curl -s https://api.github.com/repos/sqlc-dev/sqlc/releases/latest | jq -r '.tag_name')
echo "$SQLC_VERSION" >"$CUR_DIR"/.ver/sqlc
wget -qO "$CUR_DIR"/.tmp/sqlc.zip https://github.com/sqlc-dev/sqlc/releases/download/"$SQLC_VERSION"/sqlc_"${SQLC_VERSION#v}"_linux_amd64.zip
unzip -q "$CUR_DIR"/.tmp/sqlc.zip -d "$CUR_DIR"/.tmp
cp -rf "$CUR_DIR"/.tmp/sqlc "$CUR_DIR"/.bin/

# https://github.com/gotestyourself/gotestsum/releases
echo "-> gotestsum"
GOTESTSUM_VERSION=$(curl -s https://api.github.com/repos/gotestyourself/gotestsum/releases/latest | jq -r '.tag_name')
echo "$GOTESTSUM_VERSION" >"$CUR_DIR"/.ver/gotestsum
wget -qO "$CUR_DIR"/.tmp/gotestsum.tar.gz https://github.com/gotestyourself/gotestsum/releases/download/"$GOTESTSUM_VERSION"/gotestsum_"${GOTESTSUM_VERSION#v}"_linux_amd64.tar.gz
tar -xzf "$CUR_DIR"/.tmp/gotestsum.tar.gz -C "$CUR_DIR"/.tmp
cp -rf "$CUR_DIR"/.tmp/gotestsum "$CUR_DIR"/.bin/

grep -r '' "$CUR_DIR"/.ver
chmod +x "$CUR_DIR"/.bin/*

# --------------------------------------------------------------------------------

MODULES=(
    golang.org/x/tools/cmd/godoc
    golang.org/x/tools/cmd/stringer
    google.golang.org/protobuf/cmd/protoc-gen-go
    google.golang.org/grpc/cmd/protoc-gen-go-grpc
    github.com/protoc-extensions/protoc-gen-go-json
    github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway
    github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2
    github.com/go-kratos/kratos/cmd/protoc-gen-go-http/v2
    github.com/go-kratos/kratos/cmd/protoc-gen-go-errors/v2
    github.com/protoc-extensions/protoc-gen-go-json
    github.com/envoyproxy/protoc-gen-validate
    github.com/favadi/protoc-go-inject-tag
)

for module in "${MODULES[@]}"; do
    echo "-> $module"
    CGO_ENABLED=0 go install "$module@latest"
done

chmod +x "$CUR_DIR"/bin/*
