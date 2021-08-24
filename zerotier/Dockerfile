FROM starudream/alpine-glibc AS builder

ARG ZEROTIER_VERSION=1.6.5

RUN apk add --no-cache alpine-sdk linux-headers \
    && git clone --branch ${ZEROTIER_VERSION} https://github.com/zerotier/ZeroTierOne.git /build \
    && cd build \
    && make -f make-linux.mk

FROM starudream/alpine

RUN apk add --no-cache libc6-compat libstdc++

COPY --from=builder /build/zerotier-one /usr/bin/zerotier-one

RUN mkdir -p /var/lib/zerotier-one \
    && ln -s /usr/bin/zerotier-one /usr/sbin/zerotier-idtool \
    && ln -s /usr/bin/zerotier-one /usr/sbin/zerotier-cli

EXPOSE 9993/udp

CMD zerotier-one
