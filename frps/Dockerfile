FROM starudream/alpine-glibc AS builder

ARG FRP_VERSION=0.37.1

RUN apk add --no-cache wget \
    && wget -qO /tmp/frp.tar.gz https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_amd64.tar.gz \
    && tar zxf /tmp/frp.tar.gz -C /tmp \
    && mv /tmp/frp_${FRP_VERSION}_linux_amd64 /tmp/frp

FROM starudream/alpine-glibc

WORKDIR /

COPY --from=builder /tmp/frp/frps /frps
COPY --from=builder /tmp/frp/frps.ini /frps.ini

CMD /frps -c /frps.ini
