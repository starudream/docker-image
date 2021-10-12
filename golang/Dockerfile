FROM golang:1.17.2-alpine

COPY --from=starudream/upx /usr/bin/upx /usr/bin/upx
COPY --from=tonistiigi/xx:golang / /

RUN sed -i 's|dl-cdn.alpinelinux.org|mirrors.aliyun.com|g' /etc/apk/repositories \
    && go env -w CGO_ENABLED=0 GO111MODULE=on GOPROXY=https://goproxy.cn,direct
