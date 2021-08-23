FROM starudream/alpine AS builder

ARG CLASH_PREMIUM_VERSION=2021.07.03

RUN apk add --no-cache wget upx \
    && wget -qO /tmp/Country.mmdb https://github.com/Dreamacro/maxmind-geoip/releases/latest/download/Country.mmdb \
    && wget -qO /tmp/clash.gz https://github.com/Dreamacro/clash/releases/download/premium/clash-linux-amd64-${CLASH_PREMIUM_VERSION}.gz \
    && gunzip /tmp/clash.gz && chmod +x /tmp/clash \
    && upx /tmp/clash

FROM starudream/alpine-glibc

WORKDIR /

COPY --from=builder /tmp/Country.mmdb /root/.config/clash/Country.mmdb
COPY --from=builder /tmp/clash /clash

EXPOSE 7890 9090

CMD /clash
