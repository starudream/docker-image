FROM starudream/alpine-glibc AS builder

ARG MCL_VERSION=2.1.2

RUN apk add --no-cache wget zip \
    && wget -qO /tmp/mcl.zip https://github.com/iTXTech/mirai-console-loader/releases/download/v${MCL_VERSION}/mcl-${MCL_VERSION}.zip \
    && unzip -q /tmp/mcl.zip -d /tmp/mcl

FROM eclipse-temurin:17-jdk-alpine

WORKDIR /mcl

COPY --from=builder /tmp/mcl/mcl /mcl/mcl
COPY --from=builder /tmp/mcl/mcl.jar /mcl/mcl.jar

RUN chmod +x mcl \
    && ./mcl --update-package net.mamoe:mirai-api-http --type plugin --channel stable-v2 \
    && ./mcl --update-package net.mamoe:chat-command --type plugin --channel stable \
    && ./mcl --dry-run

EXPOSE 8080

CMD /mcl/mcl
