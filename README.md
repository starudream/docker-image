# Docker Image

![Docker](https://img.shields.io/github/workflow/status/starudream/docker-image/Docker/master?style=for-the-badge)
![License](https://img.shields.io/badge/License-Apache%20License%202.0-blue?style=for-the-badge)

## Usage

- `alpine`

![Version](https://img.shields.io/docker/v/starudream/alpine?style=for-the-badge)
![Size](https://img.shields.io/docker/image-size/starudream/alpine/latest?style=for-the-badge)
![Pull](https://img.shields.io/docker/pulls/starudream/alpine?style=for-the-badge)

```bash
docker pull starudream/alpine
```

- `alpine-glibc`

![Version](https://img.shields.io/docker/v/starudream/alpine-glibc?style=for-the-badge)
![Size](https://img.shields.io/docker/image-size/starudream/alpine-glibc/latest?style=for-the-badge)
![Pull](https://img.shields.io/docker/pulls/starudream/alpine-glibc?style=for-the-badge)

```bash
docker pull starudream/alpine-glibc
```

- `clash`

![Version](https://img.shields.io/docker/v/starudream/clash?style=for-the-badge)
![Size](https://img.shields.io/docker/image-size/starudream/clash/latest?style=for-the-badge)
![Pull](https://img.shields.io/docker/pulls/starudream/clash?style=for-the-badge)

```bash
docker pull starudream/clash
```

```bash
docker run -d \
    --name clash \
    --restart always \
    -p 7890:7890 \
    -p 9090:9090 \
    -v /opt/docker/clash/config.yaml:/root/.config/clash/config.yaml \
    starudream/clash:latest
```

- `frpc`

![Version](https://img.shields.io/docker/v/starudream/frpc?style=for-the-badge)
![Size](https://img.shields.io/docker/image-size/starudream/frpc/latest?style=for-the-badge)
![Pull](https://img.shields.io/docker/pulls/starudream/frpc?style=for-the-badge)

```bash
docker pull starudream/frpc
```

```bash
docker run -d \
    --name frpc \
    --restart always \
    -v /opt/docker/frpc/frpc.ini:/frpc.ini \
    starudream/frpc:latest
```

- `frps`

![Version](https://img.shields.io/docker/v/starudream/frps?style=for-the-badge)
![Size](https://img.shields.io/docker/image-size/starudream/frps/latest?style=for-the-badge)
![Pull](https://img.shields.io/docker/pulls/starudream/frps?style=for-the-badge)

```bash
docker pull starudream/frps
```

```bash
docker run -d \
    --name frps \
    --restart always \
    -p 7000:7000 \
    -v /opt/docker/frps/frps.ini:/frps.ini \
    starudream/frps:latest
```

- `h5ai`

![Version](https://img.shields.io/docker/v/starudream/h5ai?style=for-the-badge)
![Size](https://img.shields.io/docker/image-size/starudream/h5ai/latest?style=for-the-badge)
![Pull](https://img.shields.io/docker/pulls/starudream/h5ai?style=for-the-badge)

```bash
docker pull starudream/h5ai
```

```bash
docker run -d \
    --name h5ai \
    --restart always \
    -p 80:80 \
    -v /home/username:/data \
    starudream/h5ai:latest
```

- `kubectl`

![Version](https://img.shields.io/docker/v/starudream/kubectl?style=for-the-badge)
![Size](https://img.shields.io/docker/image-size/starudream/kubectl/latest?style=for-the-badge)
![Pull](https://img.shields.io/docker/pulls/starudream/kubectl?style=for-the-badge)

```bash
docker pull starudream/kubectl
```

```bash
docker run -it --rm -v /root/.kube/config:/root/.kube/config starudream/kubectl:latest
```

- `ssr-speed`

![Version](https://img.shields.io/docker/v/starudream/ssr-speed?style=for-the-badge)
![Size](https://img.shields.io/docker/image-size/starudream/ssr-speed/latest?style=for-the-badge)
![Pull](https://img.shields.io/docker/pulls/starudream/ssr-speed?style=for-the-badge)

```bash
docker pull starudream/ssr-speed
```

```bash
docker run -it --rm -v /root/.kube/config:/root/.kube/config starudream/kubectl:latest
```

## License

[Apache License 2.0](./LICENSE)
