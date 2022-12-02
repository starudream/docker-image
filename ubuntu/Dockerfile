FROM ubuntu:22.04

RUN sed -i 's|archive.ubuntu.com|mirrors.tencent.com|g' /etc/apt/sources.list \
    && sed -i 's|security.ubuntu.com|mirrors.tencent.com|g' /etc/apt/sources.list \
    && sed -i 's|ports.ubuntu.com|mirrors.tencent.com|g' /etc/apt/sources.list \
    && apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends ca-certificates tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && rm -rf /var/lib/apt/lists/*
