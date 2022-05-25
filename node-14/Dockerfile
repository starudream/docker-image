FROM node:14-alpine

RUN sed -i 's|dl-cdn.alpinelinux.org|mirrors.aliyun.com|g' /etc/apk/repositories \
    && npm config set registry=https://registry.npmmirror.com \
    && yarn config set registry https://registry.npmmirror.com
