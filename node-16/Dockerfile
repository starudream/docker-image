FROM node:16-alpine

RUN sed -i 's|dl-cdn.alpinelinux.org|mirrors.tencent.com|g' /etc/apk/repositories \
    && npm config set registry=https://registry.npmmirror.com \
    && yarn config set registry https://registry.npmmirror.com
