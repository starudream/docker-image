FROM starudream/alpine:latest AS builder

ENV FRP_VERSION 0.33.0

RUN apk add --no-cache wget upx \
    && wget -qO /tmp/frp.tar.gz https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_amd64.tar.gz \
    && tar zxf /tmp/frp.tar.gz -C /tmp \
    && mv /tmp/frp_${FRP_VERSION}_linux_amd64 /tmp/frp \
    && upx -9 -q /tmp/frp/frpc

FROM starudream/alpine-glibc:latest

WORKDIR /

COPY --from=builder /tmp/frp/frpc /frpc
COPY --from=builder /tmp/frp/frpc.ini /frpc.ini

CMD /frpc -c /frpc.ini
