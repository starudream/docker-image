FROM node:16-alpine

RUN sed -i 's|dl-cdn.alpinelinux.org|mirrors.aliyun.com|g' /etc/apk/repositories \
    && npm config set registry=https://registry.npm.taobao.org \
    && yarn config set registry https://registry.npm.taobao.org
