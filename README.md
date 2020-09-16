# Docker Image

![Docker](https://github.com/starudream/docker-image/workflows/Docker/badge.svg?branch=master)
![License](https://img.shields.io/badge/License-Apache%20License%202.0-blue)

## Usage

- `alpine`

![Version](https://img.shields.io/docker/v/starudream/alpine)
![Size](https://img.shields.io/docker/image-size/starudream/alpine/latest)
![Pull](https://img.shields.io/docker/pulls/starudream/alpine)

```bash
docker pull starudream/alpine
```

- `alpine-glibc`

![Version](https://img.shields.io/docker/v/starudream/alpine-glibc)
![Size](https://img.shields.io/docker/image-size/starudream/alpine-glibc/latest)
![Pull](https://img.shields.io/docker/pulls/starudream/alpine-glibc)

```bash
docker pull starudream/alpine-glibc
```

- `frpc`

![Version](https://img.shields.io/docker/v/starudream/frpc)
![Size](https://img.shields.io/docker/image-size/starudream/frpc/latest)
![Pull](https://img.shields.io/docker/pulls/starudream/frpc)

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

![Version](https://img.shields.io/docker/v/starudream/frps)
![Size](https://img.shields.io/docker/image-size/starudream/frps/latest)
![Pull](https://img.shields.io/docker/pulls/starudream/frps)

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

![Version](https://img.shields.io/docker/v/starudream/h5ai)
![Size](https://img.shields.io/docker/image-size/starudream/h5ai/latest)
![Pull](https://img.shields.io/docker/pulls/starudream/h5ai)

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

![Version](https://img.shields.io/docker/v/starudream/kubectl)
![Size](https://img.shields.io/docker/image-size/starudream/kubectl/latest)
![Pull](https://img.shields.io/docker/pulls/starudream/kubectl)

```bash
docker pull starudream/kubectl
```

```bash
docker run -it --rm -v /root/.kube/config:/root/.kube/config starudream/kubectl:latest
```

- `ssr-speed`

![Version](https://img.shields.io/docker/v/starudream/ssr-speed)
![Size](https://img.shields.io/docker/image-size/starudream/ssr-speed/latest)
![Pull](https://img.shields.io/docker/pulls/starudream/ssr-speed)

```bash
docker pull starudream/ssr-speed
```

```bash
docker run -it --rm -v /root/.kube/config:/root/.kube/config starudream/kubectl:latest
```

## License

[Apache License 2.0](./LICENSE)
