#!/bin/bash

#VERSION="rsync-version"
VERSION=$1

PROJECT_ROOT=$(pwd)
WORKSPACE_DIR="${PROJECT_ROOT}/workspace_dir"
STAGE_DIR="${PROJECT_ROOT}/stage_dir"
BIN_DIR="${STAGE_DIR}/bin"
ETC_DIR="${STAGE_DIR}/etc"
ZIP_DATE=$(date +%Y%m%d)
ZIP_NAME="cwrsync-x64-${ZIP_DATE}.zip"
ZIP_PATH="${PROJECT_ROOT}/${ZIP_NAME}"

if [ -z "$1" ]; then
    echo "Error: Missing required argument."
    echo "Usage: $0 <version>"
	echo "Like: build_rsync.sh 3.4.4"
    exit 1
fi

#clean up directories
rm -rf "${STAGE_DIR}"
rm -rf "${WORKSPACE_DIR}"
mkdir -p "${BIN_DIR}"
mkdir -p "${ETC_DIR}"
mkdir -p "${WORKSPACE_DIR}"

cd $WORKSPACE_DIR
wget https://download.samba.org/pub/rsync/src/rsync-${VERSION}.tar.gz
# rsync-patches no longer used after 3.4.1
#wget https://download.samba.org/pub/rsync/src/rsync-patches-${VERSION}.tar.gz
#
#if [ -e rsync-patches-${VERSION}.tar.gz ]; then
#	echo "wget failed"
#	exit 1
#fi

tar xzf rsync-${VERSION}.tar.gz

#if [ -e rsync-patches-${VERSION}.tar.gz ]; then
#	tar xzf rsync-patches-${VERSION}.tar.gz
#  else
#	wget https://download.samba.org/pub/rsync/src/rsync-patches-3.4.1.tar.gz
#	tar xzf rsync-patches-3.4.1.tar.gz
#  fi

cd rsync-${VERSION}

echo Applying patches ...
#transliterate.diff & ignore-case.diff came from rsync-patches-3.4.1.tar.gz and have been copied
#no-password-file-check.diff was already here
cp ${PROJECT_ROOT}/transliterate.diff .
cp ${PROJECT_ROOT}/ignore-case.diff .
cp ${PROJECT_ROOT}/no-password-file-check.diff .

#patch -N -p1 <patches/transliterate.diff # old path -patches tar.gz
#patch -N -p1 <patches/ignore-case.diff # old path from -patches tar.gz
patch -N -p1 <./transliterate.diff
patch -N -p1 <./ignore-case.diff
patch  <./no-password-file-check.diff

export LDFLAGS=-L/usr/local/lib
./configure --disable-acl-support --disable-xattr-support

make reconfigure
make
strip rsync.exe

cat rsync.1 | groff -mandoc -Thtml >rsync.html
cat rsyncd.conf.5 | groff -mandoc -Thtml >rsyncd.conf.html


#package
#tar cvzf ../${workspace_dir}.tar.gz rsync.exe rsync.html rsyncd.conf.html /usr/bin/ssh-add.exe /usr/bin/ssh-agent.exe /usr/bin/ssh-keygen.exe /usr/bin/ssh.exe

cp rsync.exe "${BIN_DIR}/" || { echo "Failed to copy rsync.exe"; exit 1; }

cp /usr/bin/cygcrypto-3.dll "${BIN_DIR}/" || { echo "Failed to copy cygcrypto-3.dll"; exit 1; }
cp /usr/bin/cyggcc_s-seh-1.dll "${BIN_DIR}/" || { echo "Failed to copy cyggcc_s-seh-1.dll"; exit 1; }
cp /usr/bin/cygiconv-2.dll "${BIN_DIR}/" || { echo "Failed to copy cygiconv-2.dll"; exit 1; }
cp /usr/bin/cygintl-8.dll "${BIN_DIR}/" || { echo "Failed to copy cygintl-8.dll"; exit 1; }
cp /usr/bin/cyglz4-1.dll "${BIN_DIR}/" || { echo "Failed to copy cyglz4-1.dll"; exit 1; }
cp /usr/bin/cygpopt-0.dll "${BIN_DIR}/" || { echo "Failed to copy cygpopt-0.dll"; exit 1; }
cp /usr/bin/cygwin1.dll "${BIN_DIR}/" || { echo "Failed to copy cygwin1.dll"; exit 1; }
cp /usr/bin/cygxxhash-0.dll "${BIN_DIR}/" || { echo "Failed to copy cygxxhash-0.dll"; exit 1; }
cp /usr/bin/cygz.dll "${BIN_DIR}/" || { echo "Failed to copy cygz.dll"; exit 1; }
cp /usr/bin/cygzstd-1.dll "${BIN_DIR}/" || { echo "Failed to copy cygzstd-1.dll"; exit 1; }

cp ${PROJECT_ROOT}/nsswitch.conf "${ETC_DIR}/" || { echo "Failed to copy nsswitch.conf"; exit 1; }
cp ${PROJECT_ROOT}/ssh_config "${ETC_DIR}/" || { echo "Failed to copy ssh_config"; exit 1; }

cp rsync.html "${STAGE_DIR}/" || { echo "Failed to copy rsync.html"; exit 1; }
cp rsyncd.conf.html "${STAGE_DIR}/" || { echo "Failed to copy rsyncd.conf.html"; exit 1; }
cp README.md "${STAGE_DIR}/README.rsync.txt" || { echo "Failed to copy README.rsync.txt"; exit 1; }
cp ${PROJECT_ROOT}/cwrsync.cmd "${STAGE_DIR}/" || { echo "Failed to copy cwrsync.cmd"; exit 1; }

./rsync --version

cd "${STAGE_DIR}" || exit 1

#Create .zip file:
zip -r "${ZIP_PATH}" ./*

echo "Successfully created ${ZIP_NAME}"

#cleanup
cd "${PROJECT_ROOT}" || exit 1
rm -rf "${STAGE_DIR}"
rm -rf "${WORKSPACE_DIR}"

