FROM starudream/alpine AS builder

RUN apk add --no-cache alpine-sdk linux-headers nodejs npm yarn python2 python3 \
    && npm config set registry=https://registry.npm.taobao.org \
    && yarn config set registry https://registry.npm.taobao.org
