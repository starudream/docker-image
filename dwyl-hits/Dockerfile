FROM starudream/node

WORKDIR app

RUN apk add --no-cache git \
    && git clone https://github.com/dwyl/hits-nodejs.git /app \
    && cd /app \
    && npm install

EXPOSE 8000

VOLUME /app/logs

CMD npm run start
