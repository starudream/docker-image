FROM starudream/upx AS upx

FROM starudream/alpine-glibc

COPY --from=upx /usr/bin/upx /usr/bin/upx
