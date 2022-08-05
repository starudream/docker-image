FROM golang:1.19-alpine

COPY --from=starudream/upx /usr/bin/upx /usr/bin/upx
COPY --from=tonistiigi/xx:golang / /

RUN sed -i 's|dl-cdn.alpinelinux.org|mirrors.tuna.tsinghua.edu.cn|g' /etc/apk/repositories \
    && apk add --no-cache ca-certificates tzdata make git \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && rm -rf /var/cache/apk/* \
    && go env -w CGO_ENABLED=0 GO111MODULE=on GOPROXY=https://goproxy.cn,direct
