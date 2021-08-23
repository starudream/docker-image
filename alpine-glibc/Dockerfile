FROM starudream/alpine AS builder

ARG GLIBC_VERSION=2.33-r0

RUN apk add --no-cache wget; \
    glibcURL=""; \
    apkArch=$(apk --print-arch); \
    case ${apkArch} in \
    'x86_64') \
        glibcURL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk"; \
      ;; \
    'aarch64') \
        glibcURL="https://github.com/SatoshiPortal/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}-aarch64.apk"; \
      ;; \
    *) \
        echo "unsupported architecture ${apkArch}"; exit 1; \
      ;; \
    esac; \
    wget -qO /tmp/glibc.apk ${glibcURL};

FROM starudream/alpine

COPY --from=builder /tmp/glibc.apk /tmp/glibc.apk

RUN apk add --allow-untrusted /tmp/glibc.apk && rm -rf /tmp/glibc.apk
