FROM python:3.8.5

ENV LIBSODIUM_VERSION 1.0.18
ENV SSR_SPEED_VERSION 2.7.2

RUN cd /tmp \
    && sed -i 's|deb.debian.org|mirrors.aliyun.com|g' /etc/apt/sources.list \
    && sed -i 's|security.debian.org|mirrors.aliyun.com|g' /etc/apt/sources.list \
    && apt-get update && apt-get install -y --no-install-recommends build-essential git curl && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ~/.pip && echo -e "[global]\nindex-url=https://mirrors.aliyun.com/pypi/simple/\n[install]\ntrusted-host=mirrors.aliyun.com" >~/.pip/pip.conf \
    && curl -sSLo libsodium.tar.gz https://download.libsodium.org/libsodium/releases/libsodium-${LIBSODIUM_VERSION}-stable.tar.gz \
    && tar zxf libsodium.tar.gz && cd libsodium-stable && ./configure && make -j4 && make check && make install \
    && ldconfig && ldconfig -p | grep libsodium \
    && git clone -b ${SSR_SPEED_VERSION} https://github.com/NyanChanMeow/SSRSpeed.git /SSRSpeed \
    && cd /SSRSpeed && pip install -r requirements.txt \
    && rm -rf /tmp/*

WORKDIR /SSRSpeed
