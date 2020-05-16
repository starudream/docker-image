FROM starudream/alpine:latest AS builder

ENV KUBECTL_VERSION 1.18.2

RUN apk add --no-cache curl wget upx \
    && wget -qO /tmp/kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    && chmod +x /tmp/kubectl \
    && upx -9 -q /tmp/kubectl

FROM starudream/alpine:latest

COPY --from=builder /tmp/kubectl /usr/bin/kubectl

RUN apk add --no-cache bash bash-completion \
    && mkdir -p ~/.kube \
    && kubectl completion bash >~/.kube/completion.bash.inc \
    && sed -i '/complete -o default -F __start_kubectl kubectl/a\    complete -o default -F __start_kubectl k' ~/.kube/completion.bash.inc \
    && sed -i '/complete -o default -o nospace -F __start_kubectl kubectl/a\    complete -o default -o nospace -F __start_kubectl k' ~/.kube/completion.bash.inc \
    && echo 'source /usr/share/bash-completion/bash_completion' >>~/.bashrc \
    && echo 'source ~/.kube/completion.bash.inc' >>~/.bashrc \
    && echo "alias k='kubectl'" >>~/.bashrc

CMD /bin/bash
