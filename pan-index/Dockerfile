FROM starudream/alpine-glibc-upx AS builder

ARG PAN_INDEX_VERSION=2.0.8

RUN apk add --no-cache wget \
    && wget -qO /tmp/pan-index.tar.gz https://github.com/libsgh/PanIndex/releases/download/v${PAN_INDEX_VERSION}/PanIndex-v${PAN_INDEX_VERSION}-linux-amd64.tar.gz \
    && tar zxf /tmp/pan-index.tar.gz -C /tmp \
    && upx /tmp/PanIndex

FROM starudream/alpine-glibc

WORKDIR /

COPY --from=builder /tmp/PanIndex /PanIndex

EXPOSE 5238

VOLUME /data

CMD /PanIndex
