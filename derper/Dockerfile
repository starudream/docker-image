FROM starudream/golang AS builder

ARG TS_VERSION=1.68.1

RUN cd /tmp && git clone --depth 1 -b v${TS_VERSION} https://github.com/tailscale/tailscale.git \
    && cd tailscale && CGO_ENABLED=0 go build -ldflags '-s -w' -o ./bin/derper tailscale.com/cmd/derper

FROM starudream/alpine-glibc

WORKDIR /tailscale

COPY --from=builder /tmp/tailscale/bin/derper /tailscale/derper

CMD /tailscale/derper
