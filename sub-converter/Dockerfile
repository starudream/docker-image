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

COPY nginx-default.conf /etc/nginx/http.d/default.conf
COPY entrypoint.sh /entrypoint.sh

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD wget -qO /dev/null http://localhost:25500/version || exit 1

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
