FROM node:0.10

WORKDIR /app

RUN git config --global url."https://".insteadOf git:// ; \
    npm install -g coffee-script

