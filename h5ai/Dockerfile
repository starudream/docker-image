FROM starudream/alpine:latest AS builder

ENV H5AI_VERSION 0.29.2
ENV H5AI_MD5 5cfe8ea94c5a4e27ee8d8117ef4d52c8

RUN apk add --no-cache wget zip \
    && wget -qO /tmp/h5ai.zip https://release.larsjung.de/h5ai/h5ai-${H5AI_VERSION}.zip \
    && echo ${H5AI_MD5}'  /tmp/h5ai.zip' | md5sum -c - \
    && unzip -q /tmp/h5ai.zip -d /tmp/h5ai

FROM starudream/alpine:latest

COPY --from=builder /tmp/h5ai/_h5ai/ /var/www/h5ai

RUN apk add --no-cache nginx php7-fpm php7-session php7-json \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /run/nginx /data \
    && chmod 755 -R /var/www/h5ai \
    && sed -ri "s|'ROOT_PATH.+|'ROOT_PATH', '/data');|g" /var/www/h5ai/private/php/core/class-setup.php \
    && cat >/etc/nginx/conf.d/default.conf <<EOF\nserver {\nlisten 80 default_server;\nlisten [::]:80 default_server;\nindex /public/index.php;\nlocation / {\nroot /var/www/h5ai;\nlocation /public/index.php {\nfastcgi_pass 127.0.0.1:9000;\nfastcgi_index index.php;\ninclude fastcgi.conf;\n}\n}\n}EOF \
    cat >/entrypoint.sh <<EOF\n#!/bin/sh\nnohup php-fpm7 >/var/log/php-fpm7.log 2>&1 &\nnginx -g "daemon off;"EOF

EXPOSE 80

VOLUME /data

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
