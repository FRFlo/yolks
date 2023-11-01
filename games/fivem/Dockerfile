FROM --platform=$TARGETOS/$TARGETARCH alpine:latest

LABEL author="FRFlo" maintainer="docker@frflo.ovh" version="1.0.0"
LABEL org.opencontainers.image.source="https://github.com/FRFlo/yolks"
LABEL org.opencontainers.image.licenses=GPL-3.0

RUN adduser -D -h /home/container -s /bin/sh container
RUN ln -s /home/container/ /nonexistent
ENV USER=container HOME=/home/container
WORKDIR /home/container

RUN apk update && \
    apk upgrade && \
    apk add --no-cache curl iproute2 openssl tar git git-lfs ncurses

RUN rm -rf /var/cache/apk/*

RUN git config --global pull.rebase true \
    && git config --global fetch.prune true

COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]