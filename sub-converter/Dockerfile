FROM starudream/alpine-glibc AS builder

RUN apk add --no-cache git && git clone --depth 1 --recursive https://github.com/starudream/sub-web.git /app

FROM starudream/alpine-glibc

WORKDIR /base

COPY --from=tindy2013/subconverter /usr/bin/subconverter /usr/bin/subconverter
COPY --from=tindy2013/subconverter /base /base
COPY --from=builder /app/dist /var/www/sub

RUN apk add --no-cache nginx pcre2 libcurl yaml-cpp libevent \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /etc/nginx/http.d/ /run/nginx \
    && chmod 755 -R /var/www/sub

RUN echo $'server {\n\
  listen 80 default_server;\n\
  index index.html;\n\
  location / {\n\
    root /var/www/sub;\n\
    location /sub { proxy_pass http://127.0.0.1:25500; }\n\
    location /version { proxy_pass http://127.0.0.1:25500; }\n\
  }\n\
}' >/etc/nginx/http.d/default.conf

RUN echo $'#!/bin/sh\n\
nohup subconverter >/var/log/subconverter.log 2>&1 &\n\
nginx -g "daemon off;"' >/entrypoint.sh

EXPOSE 80

VOLUME /base

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
