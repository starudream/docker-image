FROM starudream/alpine-glibc-upx AS builder

ARG NPC_VERSION=0.26.15

RUN apk add --no-cache wget \
    && wget -qO /tmp/npc.tar.gz https://github.com/yisier/nps/releases/download/v${NPC_VERSION}/linux_amd64_client.tar.gz \
    && tar zxf /tmp/npc.tar.gz -C /tmp \
    && upx /tmp/npc

FROM starudream/alpine-glibc

WORKDIR /

COPY --from=builder /tmp/npc /npc
COPY --from=builder /tmp/conf /conf

VOLUME /conf

CMD /npc
