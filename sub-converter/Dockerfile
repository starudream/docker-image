FROM tindy2013/subconverter:0.7.1 AS builder1

FROM careywong/subweb AS builder2

FROM starudream/alpine-glibc

WORKDIR /

COPY --from=builder1 /usr/bin/subconverter /usr/bin/subconverter
COPY --from=builder1 /base /base
COPY --from=builder2 /usr/share/nginx/html /var/www/sub

RUN apk add --no-cache nginx pcre2 libcurl yaml-cpp libevent \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /etc/nginx/http.d/ /run/nginx \
    && chmod 755 -R /var/www/sub

RUN echo $'server {\n\
  listen 80 default_server;\n\
  index index.html;\n\
  location / {\n\
    root /var/www/sub;\n\
    location /sub {\n\
      proxy_pass http://127.0.0.1:25500;\n\
    }\n\
  }\n\
}' >/etc/nginx/http.d/default.conf

RUN echo $'#!/bin/sh\n\
nohup subconverter >/var/log/subconverter.log 2>&1 &\n\
nginx -g "daemon off;"' >/entrypoint.sh

EXPOSE 80

VOLUME /base

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
