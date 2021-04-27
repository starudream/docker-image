FROM alpine:3.13.5

RUN sed -i 's|http://dl-cdn.alpinelinux.org|http://mirrors.aliyun.com|g' /etc/apk/repositories \
    && apk add --no-cache ca-certificates tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && rm -rf /var/cache/apk/*
