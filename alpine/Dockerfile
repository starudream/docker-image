FROM alpine:3.20

RUN sed -i 's|dl-cdn.alpinelinux.org|mirrors.cernet.edu.cn|g' /etc/apk/repositories \
    && apk add --no-cache ca-certificates tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && rm -rf /var/cache/apk/*
