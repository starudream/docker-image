FROM starudream/alpine-glibc AS builder

ARG H5AI_VERSION=0.30.0
ARG H5AI_MD5=efcc3150648cfb5b22a2b2106e2c5b7f

RUN apk add --no-cache wget zip \
    && wget -qO /tmp/h5ai.zip https://release.larsjung.de/h5ai/h5ai-${H5AI_VERSION}.zip \
    && echo ${H5AI_MD5}'  /tmp/h5ai.zip' | md5sum -c - \
    && unzip -q /tmp/h5ai.zip -d /tmp/h5ai

FROM starudream/alpine

COPY --from=builder /tmp/h5ai/_h5ai/ /var/www/h5ai

RUN apk add --no-cache nginx php7-fpm php7-session php7-json \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /etc/nginx/conf.d/ /run/nginx /data \
    && chmod 755 -R /var/www/h5ai \
    && sed -ri "s|'ROOT_PATH.+|'ROOT_PATH', '/data');|g" /var/www/h5ai/private/php/core/class-setup.php

RUN echo $'server {\n\
  listen 80 default_server;\n\
  index /public/index.php;\n\
  location / {\n\
    root /var/www/h5ai;\n\
    location /public/index.php {\n\
      fastcgi_pass 127.0.0.1:9000;\n\
      fastcgi_index index.php;\n\
      include fastcgi.conf;\n\
    }\n\
  }\n\
}' >/etc/nginx/conf.d/default.conf

RUN echo $'#!/bin/sh\n\
nohup php-fpm7 >/var/log/php-fpm7.log 2>&1 &\n\
nginx -g "daemon off;"' >/entrypoint.sh

EXPOSE 80

VOLUME /data

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
