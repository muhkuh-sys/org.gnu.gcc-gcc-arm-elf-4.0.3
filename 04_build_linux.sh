#!/bin/bash
set -e

. ./configuration.sh

mkdir -p ${BUILD_DIR_BUILD}/linux/gcc-${GCC_VER}
mkdir -p ${BUILD_DIR_BUILD}/linux/newlib-${NEWLIB_VER}
mkdir -p ${BUILD_DIR_BUILD}/linux/binutils-${BINUTILS_VER}


################
# Build Binutils
################

echo "=================================="
echo "Building binutils-${BINUTILS_VER}"
echo "=================================="

pushd ${BUILD_DIR_BUILD}/linux/binutils-${BINUTILS_VER}
# NOTE: Debug info must be enabled or linking libgcc will crash.
CFLAGS=-g ${BUILD_DIR_SRC}/binutils-${BINUTILS_VER}/configure --target=${ARM_TARGET} --prefix=${LINUX_PREFIX} --enable-interwork --enable-multilib --disable-shared --disable-nls --enable-werror=no
make all install
popd

export PATH=${PATH}:${LINUX_PREFIX}/bin
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${LINUX_PREFIX}/lib


################
# Build gcc-main
################

echo "=================================="
echo "Building GCC-${GCC_VER} (main)"
echo "=================================="

pushd ${BUILD_DIR_BUILD}/linux/gcc-${GCC_VER}
${BUILD_DIR_SRC}/gcc-${GCC_VER}/configure --target=${ARM_TARGET} --prefix=${LINUX_PREFIX} --enable-interwork --enable-multilib --enable-languages="c,c++" --with-newlib --without-headers --disable-libstdcxx-pch --disable-shared --disable-nls --disable-libssp --disable-libmudflap --disable-libgomp
make all-gcc install-gcc
popd


######################
# Build newlib library
######################

echo "=================================="
echo "Building newlib-${NEWLIB_VER}"
echo "=================================="

pushd ${BUILD_DIR_BUILD}/linux/newlib-${NEWLIB_VER}
${BUILD_DIR_SRC}/newlib-${NEWLIB_VER}/configure --target=${ARM_TARGET} --prefix=${LINUX_PREFIX} --enable-interwork --enable-multilib --disable-newlib-supplied-syscalls --enable-newlib-io-c99-formats --enable-newlib-io-long-long --enable-newlib-reent-small --enable-target-optspace
make all install
popd


######################
# Build rest of gcc
######################

echo "=================================="
echo "Building gcc-${GCC_VER}"
echo "=================================="

pushd ${BUILD_DIR_BUILD}/linux/gcc-${GCC_VER}
make all install
popd
