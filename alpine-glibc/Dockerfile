FROM starudream/alpine AS builder

ARG GLIBC_VERSION=2.33-r0

RUN apk add --no-cache wget \
    && wget -qO /tmp/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget -qO /tmp/glibc.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk

FROM starudream/alpine

COPY --from=builder /tmp/sgerrand.rsa.pub /etc/apk/keys/sgerrand.rsa.pub
COPY --from=builder /tmp/glibc.apk /tmp/glibc.apk

RUN apk add /tmp/glibc.apk && rm -rf /tmp/sgerrand.rsa.pub /tmp/glibc.apk
