FROM starudream/alpine-glibc AS builder1

ARG MIHOMO_VERSION=1.18.10

RUN case $(apk --print-arch) in \
    'x86_64') \
      export __ARCH='amd64-compatible'; \
      ;; \
    'aarch64') \
      export __ARCH='arm64'; \
      ;; \
    *) \
      echo "Unsupported architecture: $(apk --print-arch)" && exit 1; \
    esac \
    && wget -qO /tmp/geoip.metadb https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.metadb \
    && wget -qO /tmp/mihomo.gz https://github.com/MetaCubeX/mihomo/releases/download/v${MIHOMO_VERSION}/mihomo-linux-${__ARCH}-v${MIHOMO_VERSION}.gz \
    && gunzip /tmp/mihomo.gz && chmod +x /tmp/mihomo

FROM starudream/alpine-glibc AS builder2

ARG XD_VERSION=1.169.0

RUN wget -qO /tmp/xd.tgz https://github.com/MetaCubeX/metacubexd/releases/download/v${XD_VERSION}/compressed-dist.tgz \
    && mkdir -p /tmp/dist && tar xzf /tmp/xd.tgz -C /tmp/dist

FROM starudream/alpine-glibc

WORKDIR /

COPY --from=builder1 /tmp/geoip.metadb /root/.config/mihomo/geoip.metadb
COPY --from=builder1 /tmp/mihomo /mihomo
COPY --from=builder2 /tmp/dist /ui

CMD /mihomo
