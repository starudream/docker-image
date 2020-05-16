# Docker Image

![License](https://img.shields.io/badge/License-Apache%20License%202.0-blue)

## Usage

- `alpine`

![Build](https://github.com/starudream/docker-image/workflows/alpine/badge.svg)
![Version](https://img.shields.io/docker/v/starudream/alpine)
![Size](https://img.shields.io/docker/image-size/starudream/alpine/latest)
![Pull](https://img.shields.io/docker/pulls/starudream/alpine)

```bash
docker pull starudream/alpine
docker pull docker.pkg.github.com/starudream/docker-image/alpine:latest
docker pull registry.cn-shanghai.aliyuncs.com/starudream/alpine:latest
```

- `alpine-glibc`

![Build](https://github.com/starudream/docker-image/workflows/alpine-glibc/badge.svg)
![Version](https://img.shields.io/docker/v/starudream/alpine-glibc)
![Size](https://img.shields.io/docker/image-size/starudream/alpine-glibc/latest)
![Pull](https://img.shields.io/docker/pulls/starudream/alpine-glibc)

```bash
docker pull starudream/alpine-glibc
docker pull docker.pkg.github.com/starudream/docker-image/alpine-glibc:latest
docker pull registry.cn-shanghai.aliyuncs.com/starudream/alpine-glibc:latest
```

- `frpc`

![Build](https://github.com/starudream/docker-image/workflows/frpc/badge.svg)
![Version](https://img.shields.io/docker/v/starudream/frpc)
![Size](https://img.shields.io/docker/image-size/starudream/frpc/latest)
![Pull](https://img.shields.io/docker/pulls/starudream/frpc)

```bash
docker pull starudream/frpc
docker pull docker.pkg.github.com/starudream/docker-image/frpc:latest
docker pull registry.cn-shanghai.aliyuncs.com/starudream/frpc:latest
```

```bash
docker run -d \
    --name frpc \
    --restart always \
    -v /opt/docker/frpc/frpc.ini:/frpc.ini \
    starudream/frpc:latest
```

- `frps`

![Build](https://github.com/starudream/docker-image/workflows/frps/badge.svg)
![Version](https://img.shields.io/docker/v/starudream/frps)
![Size](https://img.shields.io/docker/image-size/starudream/frps/latest)
![Pull](https://img.shields.io/docker/pulls/starudream/frps)

```bash
docker pull starudream/frps
docker pull docker.pkg.github.com/starudream/docker-image/frps:latest
docker pull registry.cn-shanghai.aliyuncs.com/starudream/frps:latest
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

![Build](https://github.com/starudream/docker-image/workflows/h5ai/badge.svg)
![Version](https://img.shields.io/docker/v/starudream/h5ai)
![Size](https://img.shields.io/docker/image-size/starudream/h5ai/latest)
![Pull](https://img.shields.io/docker/pulls/starudream/h5ai)

```bash
docker pull starudream/h5ai
docker pull docker.pkg.github.com/starudream/docker-image/h5ai:latest
docker pull registry.cn-shanghai.aliyuncs.com/starudream/h5ai:latest
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

![Build](https://github.com/starudream/docker-image/workflows/kubectl/badge.svg)
![Version](https://img.shields.io/docker/v/starudream/kubectl)
![Size](https://img.shields.io/docker/image-size/starudream/kubectl/latest)
![Pull](https://img.shields.io/docker/pulls/starudream/kubectl)

```bash
docker pull starudream/kubectl
docker pull docker.pkg.github.com/starudream/docker-image/kubectl:latest
docker pull registry.cn-shanghai.aliyuncs.com/starudream/kubectl:latest
```

```bash
docker run -it --rm -v /root/.kube/config:/root/.kube/config starudream/kubectl:latest
```

## License

[Apache License 2.0](./LICENSE)
