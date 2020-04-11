FROM ubuntu:16.04

MAINTAINER simojenki

ARG OVERLAY_VERSION="v1.22.1.0"
ARG AIRVIDEOHD_VERSION="2.2.3"

RUN apt-get update && \
    apt-get -y install \
        vlc \
        bzip2 \
        libavcodec-extra && \
    apt-get autoremove -y && \
    apt-get clean -y

RUN mkdir -p /data /transcode /opt/airvideohd /videos

ADD https://s3.amazonaws.com/AirVideoHD/Download/AirVideoServerHD-$AIRVIDEOHD_VERSION.tar.bz2 /tmp/
RUN bzcat /tmp/AirVideoServerHD-$AIRVIDEOHD_VERSION.tar.bz2 | tar -xf - -C /opt/airvideohd --strip 1

ADD https://github.com/just-containers/s6-overlay/releases/download/$OVERLAY_VERSION/s6-overlay-amd64.tar.gz /tmp/
RUN gunzip -c /tmp/s6-overlay-amd64.tar.gz | tar -xf - -C /

ADD src/etc /etc

RUN rm /tmp/*

EXPOSE 5353/udp 45633 45633/udp

VOLUME /data /transcode /videos

ENTRYPOINT ["/init"]

