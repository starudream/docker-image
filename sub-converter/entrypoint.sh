#!/usr/bin/env sh

nginx -g "daemon on;"
nohup subconverter >/var/log/subconverter.log 2>&1 &
sleep 5s
tail -f /var/log/nginx/*.log /var/log/*.log
