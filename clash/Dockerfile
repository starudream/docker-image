FROM starudream/alpine AS builder

ARG CLASH_PREMIUM_VERSION=2020.08.16

RUN apk add --no-cache wget upx \
    && wget -qO /tmp/Country.mmdb https://github.com/Dreamacro/maxmind-geoip/releases/latest/download/Country.mmdb \
    && wget -qO /tmp/clash.gz https://github.com/Dreamacro/clash/releases/download/premium/clash-linux-amd64-${CLASH_PREMIUM_VERSION}.gz \
    && gunzip clash.gz && chmod +x clash \
    && upx /tmp/clash

FROM starudream/alpine-glibc

WORKDIR /

COPY --from=builder /tmp/Country.mmdb /root/.config/clash/Country.mmdb
COPY --from=builder /tmp/clash /clash

CMD /clash