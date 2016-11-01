#!/bin/bash

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
aptly publish --skip-signing repo freeipmi-testing && \
aptly serve

