FROM golang:1.24-alpine3.22

RUN apk add --no-cache ca-certificates tzdata bash make git upx curl unzip jq \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && rm -rf /var/cache/apk/* \
    && sed -i 's|dl-cdn.alpinelinux.org|mirrors.huaweicloud.com|g' /etc/apk/repositories \
    && go env -w CGO_ENABLED=0 GO111MODULE=on GOPROXY=https://goproxy.cn,https://goproxy.io,direct
