FROM starudream/alpine-glibc AS builder

ARG UPX_VERSION=3.96

RUN apk add --no-cache wget; \
    upxArch=""; \
    apkArch=$(apk --print-arch); \
    case ${apkArch} in \
    'x86_64') \
        upxArch="amd64"; \
      ;; \
    'aarch64') \
        upxArch="arm64"; \
      ;; \
    *) \
        echo "unsupported architecture ${apkArch}"; exit 1; \
      ;; \
    esac; \
    wget -qO /tmp/upx.tar.xz https://github.com/upx/upx/releases/download/v${UPX_VERSION}/upx-${UPX_VERSION}-${upxArch}_linux.tar.xz; \
    tar Jxf /tmp/upx.tar.xz -C /tmp && mv /tmp/upx-${UPX_VERSION}-${upxArch}_linux/upx /tmp/upx && chmod +x /tmp/upx;

FROM starudream/alpine-glibc

COPY --from=builder /tmp/upx /usr/bin/upx

CMD upx
