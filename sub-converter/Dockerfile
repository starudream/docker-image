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
    && chmod 755 -R /var/www/sub \
    && cd /usr/lib && ln -sf libyaml-cpp.so.0.8.0 libyaml-cpp.so.0.7

COPY nginx-default.conf /etc/nginx/http.d/default.conf
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
