FROM golang:1.23-alpine3.20

RUN apk add --no-cache ca-certificates tzdata make git upx \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && rm -rf /var/cache/apk/* \
    && sed -i 's|dl-cdn.alpinelinux.org|mirrors.cernet.edu.cn|g' /etc/apk/repositories \
    && go env -w CGO_ENABLED=0 GO111MODULE=on GOPROXY=https://goproxy.cn,https://goproxy.io,direct
