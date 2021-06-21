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

- `dwyl-hits`

![Version](https://img.shields.io/docker/v/starudream/dwyl-hits?style=for-the-badge)
![Size](https://img.shields.io/docker/image-size/starudream/dwyl-hits/latest?style=for-the-badge)
![Pull](https://img.shields.io/docker/pulls/starudream/dwyl-hits?style=for-the-badge)

```bash
docker pull starudream/dwyl-hits
```

```bash
docker run -d \
    --name dwyl-hits \
    --restart always \
    -p 8000:8000 \
    -v /opt/docker/hits/logs:/app/logs \
    starudream/dwyl-hits:latest
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

- `golang`

![Version](https://img.shields.io/docker/v/starudream/golang?style=for-the-badge)
![Size](https://img.shields.io/docker/image-size/starudream/golang/latest?style=for-the-badge)
![Pull](https://img.shields.io/docker/pulls/starudream/golang?style=for-the-badge)

```bash
docker pull starudream/golang
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

- `ubuntu`

![Version](https://img.shields.io/docker/v/starudream/ubuntu?style=for-the-badge)
![Size](https://img.shields.io/docker/image-size/starudream/ubuntu/latest?style=for-the-badge)
![Pull](https://img.shields.io/docker/pulls/starudream/ubuntu?style=for-the-badge)

```bash
docker pull starudream/ubuntu
```

- `zerotier`

![Version](https://img.shields.io/docker/v/starudream/zerotier?style=for-the-badge)
![Size](https://img.shields.io/docker/image-size/starudream/zerotier/latest?style=for-the-badge)
![Pull](https://img.shields.io/docker/pulls/starudream/zerotier?style=for-the-badge)

```bash
docker pull starudream/zerotier
```

```bash
docker run -d \
    --name zerotier \
    --restart always \
    --device=/dev/net/tun \
    --net=host \
    -v /opt/docker/zerotier:/var/lib/zerotier-one \
    starudream/zerotier:latest
```

## License

[Apache License 2.0](./LICENSE)
