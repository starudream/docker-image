FROM starudream/alpine-glibc-upx AS builder

ARG ALIST_VERSION=3.16.0

RUN apk add --no-cache wget \
    && wget -qO /tmp/alist.tar.gz https://github.com/alist-org/alist/releases/download/v${ALIST_VERSION}/alist-linux-musl-amd64.tar.gz \
    && tar zxf /tmp/alist.tar.gz -C /tmp

FROM starudream/alpine-glibc

WORKDIR /

COPY --from=builder /tmp/alist /

EXPOSE 5244

VOLUME /data

CMD /alist server --no-prefix
