#
# Dockerfile to build debian packages from https://github.com/chu11/freeipmi-mirror master branche.
#

FROM debian:jessie

MAINTAINER Lukas Reusser <reusserl@users.noreply.github.com>

RUN \ 
    apt-get update && \ 
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    build-essential \
    libgcrypt11-dev \
    fakeroot \
    devscripts \
    debhelper \
    git \
    autotools-dev \
    chrpath \
    libdistro-info-perl \
    autoconf \
    automake \
    libtool \
    ca-certificates \
    aptly \
    texinfo && \
    mkdir -p /usr/src/packages && \
    rm -rf /var/lib/apt/lists/*
	
ADD http://http.debian.net/debian/pool/main/f/freeipmi/freeipmi_1.4.11-1.1.debian.tar.xz /usr/src/packages
ADD rules /usr/src/packages
ADD CMD.sh /root

CMD ["bash", "/root/CMD.sh"]

EXPOSE 8080
