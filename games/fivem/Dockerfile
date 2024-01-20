FROM --platform=$TARGETOS/$TARGETARCH debian:bookworm-slim

LABEL author="FRFlo" maintainer="docker@frflo.ovh" version="1.0.0"
LABEL org.opencontainers.image.source="https://github.com/FRFlo/yolks"
LABEL org.opencontainers.image.licenses=GPL-3.0

ENV DEBIAN_FRONTEND noninteractive

RUN useradd -m -d /home/container -s /bin/bash container
RUN ln -s /home/container/ /nonexistent
ENV USER=container HOME=/home/container
WORKDIR /home/container

RUN apt update && \
    apt upgrade -y && \
    apt install -y curl iproute2 openssl tar git git-lfs

RUN apt install -y gcc g++ libgcc1 libc++-dev gdb libc6 git wget zip unzip binutils xz-utils liblzo2-2 cabextract net-tools netcat-openbsd telnet libatomic1 libsdl1.2debian libsdl2-2.0-0 \
    libfontconfig icu-devtools libunwind8 libssl-dev sqlite3 libsqlite3-dev libmariadbclient-dev-compat locales ffmpeg gnupg2 apt-transport-https software-properties-common ca-certificates \
    liblua5.3-0 libz-dev rapidjson-dev tzdata libevent-dev libzip4 procps libstdc++6 tini

RUN update-locale lang=en_US.UTF-8 && \
    dpkg-reconfigure --frontend noninteractive locales

STOPSIGNAL SIGINT

RUN git config --global pull.rebase true \
    && git config --global fetch.prune true

COPY --chown=container:container ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]