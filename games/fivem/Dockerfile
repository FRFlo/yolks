FROM --platform=$TARGETOS/$TARGETARCH alpine

LABEL author="FRFlo" maintainer="docker@frflo.ovh" version="1.0.0"
LABEL org.opencontainers.image.source="https://github.com/FRFlo/yolks"
LABEL org.opencontainers.image.licenses=GPL-3.0

ENV DEBIAN_FRONTEND noninteractive

RUN useradd -m -d /home/container -s /bin/bash container
RUN ln -s /home/container/ /nonexistent
ENV USER=container HOME=/home/container
WORKDIR /home/container

RUN apk update && apk upgrade

RUN apk add --no-cache curl iproute2 apk-tools openssl tar git git-lfs

RUN git config --global pull.rebase true \
    && git config --global fetch.prune true

COPY ./entrypoint.sh /entrypoint.sh
CMD [ "/bin/bash", "/entrypoint.sh" ]