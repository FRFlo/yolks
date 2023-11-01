FROM --platform=$TARGETOS/$TARGETARCH debian

LABEL author="FRFlo" maintainer="docker@frflo.ovh" version="1.0.0"
LABEL org.opencontainers.image.source="https://github.com/FRFlo/yolks"
LABEL org.opencontainers.image.licenses=GPL-3.0

ENV DEBIAN_FRONTEND noninteractive

RUN useradd -m -d /home/container -s /bin/bash container
RUN ln -s /home/container/ /nonexistent
ENV USER=container HOME=/home/container
WORKDIR /home/container

RUN apt-get update && apt-get full-upgrade -y

RUN apt-get install -y curl iproute2 apt-transport-https software-properties-common ca-certificates \
    openssl tar git git-lfs

RUN git config --global pull.rebase true \
    && git config --global fetch.prune true

COPY ./entrypoint.sh /entrypoint.sh
CMD [ "/bin/bash", "/entrypoint.sh" ]