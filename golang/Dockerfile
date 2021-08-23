FROM starudream/upx AS upx

FROM golang:1.17.0-alpine

COPY --from=upx /usr/bin/upx /usr/bin/upx

RUN sed -i 's|dl-cdn.alpinelinux.org|mirrors.aliyun.com|g' /etc/apk/repositories \
    && go env -w CGO_ENABLED=0 GO111MODULE=on GOPROXY=https://goproxy.cn,direct
