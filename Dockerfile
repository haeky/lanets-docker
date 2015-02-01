FROM ubuntu:14.04

MAINTAINER Laurent Dang <dang.laurent@gmail.com>

RUN apt-get update && \
    apt-get install -y curl lib32gcc1 git

RUN useradd -m lanets

RUN mkdir -p /home/lanets/steamcmd && \
    cd /home/lanets/steamcmd && \
    curl -O http://media.steampowered.com/installer/steamcmd_linux.tar.gz && \
    tar -xvzf steamcmd_linux.tar.gz && \
    rm steamcmd_linux.tar.gz

RUN mkdir -p /home/lanets/servers/csgo &&\
  cd /home/lanets/steamcmd &&\
  ./steamcmd.sh \
    +login anonymous \
    +force_install_dir ../servers/csgo \
    +app_update 740 validate \
    +quit

RUN cd /home/lanets && |
    git clone https://github.com/lanets/counter-strike-servers-configuration.git && \
    cp -f /home/lanets/counter-strike-servers-configuration/gamemode_competitive.cfg /home/lanets/servers/csgo/cfg/gamemode_competitive.cfg && \
    rm -rf counter-strike-servers-configuration

EXPOSE 27015

WORKDIR /home/lanets/servers/csgo
ENTRYPOINT ["./srcds_run"]
