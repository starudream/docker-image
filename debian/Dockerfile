FROM debian:11.5

RUN sed -i 's|deb.debian.org|mirrors.tuna.tsinghua.edu.cn|g' /etc/apt/sources.list \
    && apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends ca-certificates tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && rm -rf /var/lib/apt/lists/*
