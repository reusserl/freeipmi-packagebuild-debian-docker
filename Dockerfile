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

RUN \
    SOURCE_ROOT=/usr/src/packages \
    PKG_VERSION=1.5.4 \
    PKG_NAME=freeipmi \
    PKG_PATH=${SOURCE_ROOT}/${PKG_NAME} && \
    export DEBEMAIL='github@luke.ch' && \
    export DEBFULLNAME='Lukas Reusser' && \
    cd $SOURCE_ROOT && \
    git clone https://github.com/chu11/freeipmi-mirror ${PKG_NAME}-${PKG_VERSION} && \
    tar czf ${PKG_NAME}_${PKG_VERSION}.orig.tar.gz ${PKG_NAME}-${PKG_VERSION} && \
    cd ${PKG_NAME}-${PKG_VERSION} && \
    tar xf ../freeipmi_*debian.tar.*z && \
    cp ${SOURCE_ROOT}/rules ${SOURCE_ROOT}/${PKG_NAME}-${PKG_VERSION}/debian/rules && \
    debchange --distribution testing --package "${PKG_NAME}" --newversion ${PKG_VERSION}-1 "Fresh version from git master" && \
    debuild -us -uc && \
    aptly repo create -component="main" -distribution="testing" -comment="Freeipmi Testing Repository (from GIT master)" freeipmi-testing && \
    aptly repo add freeipmi-testing ${SOURCE_ROOT}/*.deb && \
    aptly publish --skip-signing repo freeipmi-testing 

CMD ["aptly", "serve"]

EXPOSE 8080
