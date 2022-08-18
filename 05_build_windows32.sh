#!/bin/bash
set -e

. ./configuration.sh

mkdir -p ${BUILD_DIR_BUILD}/windows_x86/gcc-${GCC_VER}
mkdir -p ${BUILD_DIR_BUILD}/windows_x86/binutils-${BINUTILS_VER}


################
# Build Binutils
################

echo "=================================="
echo "Building binutils-${BINUTILS_VER}"
echo "=================================="

pushd ${BUILD_DIR_BUILD}/windows_x86/binutils-${BINUTILS_VER}
${BUILD_DIR_SRC}/binutils-${BINUTILS_VER}/configure --target=${ARM_TARGET} --prefix=${WINDOWS_X86_PREFIX} --enable-interwork --enable-multilib --disable-shared --disable-nls --enable-werror=no --host=i686-w64-mingw32 --build=x86_64-unknown-linux-gnu
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

# Copy the specs file from the linux version.
mkdir -p ${BUILD_DIR_BUILD}/windows_x86/gcc-${GCC_VER}/gcc
cp ${BUILD_DIR_BUILD}/linux/gcc-${GCC_VER}/gcc/xgcc ${BUILD_DIR_BUILD}/windows_x86/gcc-${GCC_VER}/gcc/

# Copy the fixincl tool.
mkdir -p ${BUILD_DIR_BUILD}/windows_x86/gcc-${GCC_VER}/build-i686-w64-mingw32/fixincludes
cp ${BUILD_DIR_BUILD}/linux/gcc-${GCC_VER}/fixincludes/fixincl ${BUILD_DIR_BUILD}/windows_x86/gcc-${GCC_VER}/build-i686-w64-mingw32/fixincludes/

mkdir -p ${WINDOWS_X86_PREFIX}/${ARM_TARGET}
mkdir -p ${WINDOWS_X86_PREFIX}/${ARM_TARGET}
mkdir -p ${WINDOWS_X86_PREFIX}/share
mkdir -p ${WINDOWS_X86_PREFIX}/lib
cp -r ${LINUX_PREFIX}/${ARM_TARGET}/lib     ${WINDOWS_X86_PREFIX}/${ARM_TARGET}/
cp -r ${LINUX_PREFIX}/${ARM_TARGET}/include ${WINDOWS_X86_PREFIX}/${ARM_TARGET}/
cp -r ${LINUX_PREFIX}/share                 ${WINDOWS_X86_PREFIX}/
cp -r ${LINUX_PREFIX}/lib/gcc               ${WINDOWS_X86_PREFIX}/lib

pushd ${BUILD_DIR_BUILD}/windows_x86/gcc-${GCC_VER}
CC=i686-w64-mingw32-gcc ${BUILD_DIR_SRC}/gcc-${GCC_VER}/configure --target=${ARM_TARGET} --prefix=${WINDOWS_X86_PREFIX} --enable-interwork --enable-multilib --enable-languages="c,c++" --with-newlib --without-headers --disable-libstdcxx-pch --disable-shared --disable-nls --disable-libssp --disable-libmudflap --disable-libgomp --with-host-libstdcxx='-static-libgcc -Wl,-Bstatic,-lstdc++,-Bdynamic -lm' --host=i686-w64-mingw32 --build=x86_64-unknown-linux-gnu
make all-gcc install-gcc
popd
