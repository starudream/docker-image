FROM golang:1.24-alpine3.21

RUN apk add --no-cache ca-certificates tzdata bash make git upx curl unzip jq \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && rm -rf /var/cache/apk/* \
    && sed 's|dl-cdn.alpinelinux.org|mirror.nju.edu.cn|g' /etc/apk/repositories > /etc/apk/repositories-mirror \
    && go env -w CGO_ENABLED=0 GO111MODULE=on GOPROXY=https://goproxy.cn,https://goproxy.io,direct
