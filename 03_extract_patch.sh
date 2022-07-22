#!/bin/bash
set -e

. ./configuration.sh

mkdir -p ${BUILD_DIR_SRC}

#################
# Extract Sources
#################
pushd ${BUILD_DIR_SRC}

echo "Unpacking ${GCC}"
tar xjf ${DOWNLOAD_DIR}/${GCC}
pushd gcc-${GCC_VER}
for strPatch in `ls ${PRJ_DIR}/patches/gcc-${GCC_VER}`; do
  patch -p1 < ${PRJ_DIR}/patches/gcc-${GCC_VER}/${strPatch}
done
popd

echo "Unpacking ${BINUTILS}"
tar xjf ${DOWNLOAD_DIR}/${BINUTILS}
pushd binutils-${BINUTILS_VER}
for strPatch in `ls ${PRJ_DIR}/patches/binutils-${BINUTILS_VER}`; do
  patch -p1 < ${PRJ_DIR}/patches/binutils-${BINUTILS_VER}/${strPatch}
done
popd

echo "Unpacking ${NEWLIB}"
tar xzf ${DOWNLOAD_DIR}/${NEWLIB}
pushd newlib-${NEWLIB_VER}
for strPatch in `ls ${PRJ_DIR}/patches/newlib-${NEWLIB_VER}`; do
  patch -p1 < ${PRJ_DIR}/patches/newlib-${NEWLIB_VER}/${strPatch}
done
popd

popd
