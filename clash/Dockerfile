FROM starudream/alpine-glibc AS builder

ARG CLASH_PREMIUM_VERSION=2021.09.15

RUN apk add --no-cache wget; \
    clashArch=""; \
    apkArch=$(apk --print-arch); \
    case ${apkArch} in \
    'x86_64') \
        clashArch="amd64"; \
      ;; \
    'aarch64') \
        clashArch="armv8"; \
      ;; \
    *) \
        echo "unsupported architecture ${apkArch}"; exit 1; \
      ;; \
    esac; \
    wget -qO /tmp/Country.mmdb https://github.com/Dreamacro/maxmind-geoip/releases/latest/download/Country.mmdb; \
    wget -qO /tmp/clash.gz https://github.com/Dreamacro/clash/releases/download/premium/clash-linux-${clashArch}-${CLASH_PREMIUM_VERSION}.gz; \
    gunzip /tmp/clash.gz && chmod +x /tmp/clash;

FROM starudream/alpine-glibc

WORKDIR /

COPY --from=builder /tmp/Country.mmdb /root/.config/clash/Country.mmdb
COPY --from=builder /tmp/clash /clash

EXPOSE 7890 9090

CMD /clash
