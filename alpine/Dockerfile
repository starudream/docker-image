FROM alpine:3.22

RUN apk add --no-cache ca-certificates tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && rm -rf /var/cache/apk/* \
    && sed -i 's|dl-cdn.alpinelinux.org|mirror.nju.edu.cn|g' /etc/apk/repositories
