#!/bin/sh

nohup php-fpm7 >/var/log/php-fpm7.log 2>&1 &

nginx -g "daemon off;"
