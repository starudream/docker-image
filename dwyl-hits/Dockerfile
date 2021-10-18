FROM starudream/node-14

WORKDIR app

RUN apk add --no-cache git \
    && git clone --depth 1 --recursive https://github.com/starudream/hits-nodejs.git /app \
    && cd /app \
    && npm install

EXPOSE 8000

VOLUME /app/logs

CMD npm run start
