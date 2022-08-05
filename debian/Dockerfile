FROM debian:11.4

RUN sed -i 's|deb.debian.org|mirrors.tuna.tsinghua.edu.cn|g' /etc/apt/sources.list \
    && apt update && DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends ca-certificates tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && rm -rf /var/lib/apt/lists/*
