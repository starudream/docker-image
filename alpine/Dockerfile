FROM alpine:3.17

RUN sed -i 's|dl-cdn.alpinelinux.org|mirrors.tencent.com|g' /etc/apk/repositories \
    && apk add --no-cache ca-certificates tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && rm -rf /var/cache/apk/*
