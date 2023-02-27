FROM starudream/alpine-glibc-upx AS builder1

ARG CLASH_PREMIUM_VERSION=2023.02.16

RUN apk add --no-cache wget; \
    clashArch=""; \
    apkArch=$(apk --print-arch); \
    case ${apkArch} in \
    'x86_64') \
        clashArch="amd64"; \
      ;; \
    'aarch64') \
        clashArch="arm64"; \
      ;; \
    *) \
        echo "unsupported architecture ${apkArch}"; exit 1; \
      ;; \
    esac; \
    wget -qO /tmp/Country.mmdb https://github.com/Dreamacro/maxmind-geoip/releases/latest/download/Country.mmdb; \
    wget -qO /tmp/clash.gz https://github.com/Dreamacro/clash/releases/download/premium/clash-linux-${clashArch}-${CLASH_PREMIUM_VERSION}.gz; \
    gunzip /tmp/clash.gz && chmod +x /tmp/clash; \
    upx /tmp/clash;

FROM starudream/alpine-glibc AS builder2

ARG YACD_VERSION=0.3.8

RUN apk add --no-cache wget xz \
    && wget -qO /tmp/yacd.tar.xz https://github.com/haishanh/yacd/releases/download/v${YACD_VERSION}/yacd.tar.xz \
    && xz -d /tmp/yacd.tar.xz \
    && tar xf /tmp/yacd.tar -C /tmp

FROM starudream/alpine-glibc

WORKDIR /

COPY --from=builder1 /tmp/Country.mmdb /root/.config/clash/Country.mmdb
COPY --from=builder1 /tmp/clash /clash
COPY --from=builder2 /tmp/public /ui

EXPOSE 7890 9090

VOLUME /ui

CMD /clash
