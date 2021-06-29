FROM starudream/alpine AS builder

ARG NPS_VERSION=0.26.10

RUN apk add --no-cache wget upx \
    && wget -qO /tmp/nps.tar.gz https://github.com/ehang-io/nps/releases/download/v${NPS_VERSION}/linux_amd64_server.tar.gz \
    && tar zxf /tmp/nps.tar.gz -C /tmp \
    && upx /tmp/nps

FROM starudream/alpine-glibc

WORKDIR /

COPY --from=builder /tmp/nps /nps
COPY --from=builder /tmp/web /web
COPY --from=builder /tmp/conf /conf

VOLUME /conf

CMD /nps
