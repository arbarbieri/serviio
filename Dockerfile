# Utiliza a rede do host (para ficar visível na rede local) 
# Mapeia a pasta /home/arquivos do host para /media/serviio (repositório de arquivos de mídia)
# 
# docker run --name serviio-custom -d --network host --restart=unless-stopped -p 23423:23423/tcp -p 23424:23424/tcp -p 8895:8895/tcp -p 1900:1900/udp -v /etc/localtime:/etc/localtime:ro -v /home/arquivos:/media/serviio serviio-custom

FROM alpine

ARG BUILD_DATE
ARG VERSION=2.2

MAINTAINER alexandre barbieri <alexandrebarbieri@gmail.com>

LABEL org.label-schema.build-date=$BUILD_DATE \
        org.label-schema.name="DLNA Serviio Container" \
        org.label-schema.description="DLNA Serviio Container" \
        org.label-schema.schema-version="1.0" \
        maintainer="alexandre barbieri <alexandrebarbieri@gmail.com>"

RUN apk update && apk add ffmpeg openjdk8 
#        cd /tmp && \

WORKDIR /tmp
RUN wget https://download.serviio.org/releases/serviio-${VERSION}-linux.tar.gz && \
        mkdir /opt/serviio -p && \
        mkdir /opt/serviio/log -p && \
        mkdir /media/serviio && \
        tar xvzf serviio-${VERSION}-linux.tar.gz -C /opt/serviio --strip-components 1 && \
        touch /opt/serviio/log/serviio.log

RUN     rm -rf /var/cache/apk/*

CMD tail -f /opt/serviio/log/serviio.log & /opt/serviio/bin/./serviio.sh
