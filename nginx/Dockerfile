FROM starudream/debian

RUN apt install -y --no-install-recommends wget systemctl \
    && wget -qO /tmp/oneinstack.tar.gz http://mirrors.linuxeye.com/oneinstack.tar.gz \
    && tar zxf /tmp/oneinstack.tar.gz -C /opt \
    && bash /opt/oneinstack/install.sh --nginx_option 3 \
    && /usr/local/openresty/nginx/sbin/nginx -v
