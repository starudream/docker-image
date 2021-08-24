FROM starudream/alpine AS builder

ARG UPX_VERSION=3.96

RUN apk add --no-cache alpine-sdk linux-headers ucl-dev zlib-dev zlib-static \
    && git clone --depth 1 --recursive --branch "v${UPX_VERSION}" https://github.com/upx/upx.git /upx \
    && cd /upx/src && make -j8 LDFLAGS=-static CHECK_WHITESPACE= upx.out \
    && ./upx.out --best -o /usr/bin/upx /upx/src/upx.out

FROM starudream/alpine

COPY --from=builder /usr/bin/upx /usr/bin/upx

CMD upx
