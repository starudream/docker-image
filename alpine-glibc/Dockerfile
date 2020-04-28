FROM alpine:latest AS builder

ENV GLIBC_VERSION 2.31-r0

RUN sed -i 's|http://dl-cdn.alpinelinux.org|https://mirrors.tuna.tsinghua.edu.cn|g' /etc/apk/repositories \
    && apk add --no-cache ca-certificates wget \
    && wget -qO /tmp/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget -qO /tmp/glibc.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk

FROM starudream/alpine:latest

COPY --from=builder /tmp/sgerrand.rsa.pub /etc/apk/keys/sgerrand.rsa.pub
COPY --from=builder /tmp/glibc.apk /tmp/glibc.apk

RUN apk add /tmp/glibc.apk && rm -rf /tmp/sgerrand.rsa.pub /tmp/glibc.apk
