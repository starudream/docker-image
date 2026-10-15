FROM python:3.14.8-slim-bookworm

ARG TARGETARCH

ENV PATH=/opt/venv/bin:$PATH \
    LANG=C.UTF-8 \
    HOME=/home/camoufox \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1920 \
    DISPLAY_HEIGHT=1080 \
    CAMOUFOX_EXECUTABLE_PATH=/opt/camoufox/camoufox-bin \
    CAMOUFOX_HOST=0.0.0.0 \
    CAMOUFOX_PORT=3000 \
    CAMOUFOX_WS_PATH=ws \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

RUN set -eux; \
    case "$TARGETARCH" in \
      amd64) \
        kasmvnc_sha256=770fd3df51510beecc89666879d82faf411276e68c6e11df612f736b891b5f71; \
        camoufox_arch=x86_64; \
        camoufox_sha256=72637885ee67c93466ad377831c647192f8f08fb5c6fd9279de1320b49dd2b53 \
        ;; \
      arm64) \
        kasmvnc_sha256=aa83a1a6c9069d1a02239988b07a3a2a082a433042b4d4ee2b9e9f6b2df9643c; \
        camoufox_arch=arm64; \
        camoufox_sha256=8b5fd083721c807ee2a752265683482477105052fa0e21739388b527ae067c15 \
        ;; \
      *) echo "Unsupported architecture: $TARGETARCH" >&2; exit 1 ;; \
    esac; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates curl fluxbox fontconfig fonts-noto-cjk openssl \
      supervisor tzdata unzip x11-utils; \
    fc-cache -f -s; \
    curl -fsSL --retry 3 \
      "https://github.com/kasmtech/KasmVNC/releases/download/v1.5.0/kasmvncserver_bookworm_1.5.0_${TARGETARCH}.deb" \
      -o /tmp/kasmvnc.deb; \
    printf '%s  %s\n' "$kasmvnc_sha256" /tmp/kasmvnc.deb | sha256sum -c -; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends /tmp/kasmvnc.deb; \
    curl -fsSL --retry 3 \
      "https://github.com/daijro/camoufox/releases/download/v156.0.1-beta.36/camoufox-156.0.1-beta.36-lin.${camoufox_arch}.zip" \
      -o /tmp/camoufox.zip; \
    printf '%s  %s\n' "$camoufox_sha256" /tmp/camoufox.zip | sha256sum -c -; \
    mkdir -p /opt/camoufox; \
    unzip -q /tmp/camoufox.zip -d /opt/camoufox; \
    chmod -R 755 /opt/camoufox; \
    test -x "$CAMOUFOX_EXECUTABLE_PATH"; \
    rm -f /tmp/kasmvnc.deb /tmp/camoufox.zip \
      /etc/ssl/private/ssl-cert-snakeoil.key /etc/ssl/certs/ssl-cert-snakeoil.pem; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    python -m venv /opt/venv; \
    pip install --no-cache-dir camoufox==0.5.8 playwright==1.62.0; \
    playwright install-deps firefox; \
    rm -rf /var/lib/apt/lists/*; \
    groupadd --gid 1000 camoufox; \
    useradd --uid 1000 --gid camoufox --create-home --home-dir "$HOME" --shell /bin/bash camoufox; \
    chown -R camoufox:camoufox /opt/venv; \
    install -d -m 0700 -o camoufox -g camoufox "$HOME/.vnc"; \
    mkdir -p /tmp/.X11-unix; \
    chmod 1777 /tmp/.X11-unix

COPY --chown=camoufox:camoufox kasmvnc.yaml /home/camoufox/.vnc/kasmvnc.yaml
COPY supervisord.conf entrypoint.py server.py /app/
COPY --chmod=755 xstartup.sh /app/xstartup.sh

USER camoufox

RUN python -c 'from camoufox.fpgen_model import ensure_fpgen_model; ensure_fpgen_model()'

EXPOSE 3000 8443

CMD ["python", "/app/entrypoint.py"]
