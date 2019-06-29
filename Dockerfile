FROM ubuntu:18.04

ENV DEBIAN_FRONTEND "noninteractive"

ENV STEAM_USER "steam"
ENV STEAM_APP_DIR "/home/steam/csgo-dedicated"
ENV STEAM_CMD_DIR "/home/steam/.steam"
ENV STEAM_CMD_URL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz"

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
      locales \
      apt-utils \
      lib32gcc1 \
      curl \
      ca-certificates && \
    apt-get -y dist-upgrade && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    echo en_US UTF-8 >> /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure --frontend=noninteractive locales

RUN useradd -ms /bin/bash "${STEAM_USER}" && \
    mkdir "${STEAM_CMD_DIR}" && cd "${STEAM_CMD_DIR}" && \
    curl -L "${STEAM_CMD_URL}" | tar xz && \
    mkdir -p "${STEAM_CMD_DIR}"/sdk32/ && \
    ln -s "${STEAM_CMD_DIR}"/Steam/linux32/steamclient.so "${STEAM_CMD_DIR}"/sdk32/steamclient.so && \
    chown steam:steam "${STEAM_CMD_DIR}" -R

USER steam

WORKDIR "${STEAM_CMD_DIR}"

CMD ["./steamcmd.sh"]

EXPOSE 27015/tcp 27015/udp
