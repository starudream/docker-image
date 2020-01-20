FROM starudream/alpine:latest AS builder

ENV H5AI_VERSION 0.29.2
ENV H5AI_MD5 5cfe8ea94c5a4e27ee8d8117ef4d52c8

RUN apk add --no-cache wget zip \
    && wget -qO /tmp/h5ai.zip https://release.larsjung.de/h5ai/h5ai-${H5AI_VERSION}.zip \
    && echo ${H5AI_MD5}'  /tmp/h5ai.zip' | md5sum -c - \
    && unzip -q /tmp/h5ai.zip -d /tmp/h5ai

FROM starudream/alpine:latest

COPY --from=builder /tmp/h5ai/_h5ai/ /var/www/h5ai
COPY default.conf /etc/nginx/conf.d/default.conf

RUN apk add --no-cache nginx php7-fpm php7-session php7-json \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /run/nginx /data \
    && chmod 755 -R /var/www/h5ai \
    && sed -ri "s|'ROOT_PATH.+|'ROOT_PATH', '/data');|g" /var/www/h5ai/private/php/core/class-setup.php

EXPOSE 80

VOLUME /data

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]