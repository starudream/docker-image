FROM starudream/golang AS builder

COPY init.sh /go/init.sh

RUN apk add --no-cache ca-certificates tzdata bash make git upx curl unzip jq && chmod +x /go/init.sh && bash /go/init.sh

FROM golang:1.24-alpine3.21

COPY --from=builder /go/.bin/ /usr/local/bin/
COPY --from=builder /go/.ver/ /usr/local/bin/.ver/
COPY --from=builder /go/bin/ /go/bin/

RUN apk add --no-cache openssh rsync && rm -rf /var/cache/apk/*
