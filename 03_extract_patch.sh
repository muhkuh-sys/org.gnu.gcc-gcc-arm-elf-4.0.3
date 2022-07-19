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
patch -p1 < ${PRJ_DIR}/patches/gcc-${GCC_VER}/netx-config.patch
patch -p1 < ${PRJ_DIR}/patches/gcc-${GCC_VER}/mingw_insn_outofmemory.patch
patch -p1 < ${PRJ_DIR}/patches/gcc-${GCC_VER}/disable_inlines_for_gcc5.patch
patch -p1 < ${PRJ_DIR}/patches/gcc-${GCC_VER}/add_mode_for_open.patch
patch -p1 < ${PRJ_DIR}/patches/gcc-${GCC_VER}/support_mingw64.diff
popd

echo "Unpacking ${BINUTILS}"
tar xjf ${DOWNLOAD_DIR}/${BINUTILS}
pushd binutils-${BINUTILS_VER}
patch -p1 < ${PRJ_DIR}/patches/binutils-${BINUTILS_VER}/add_mingw_header.patch
popd

echo "Unpacking ${NEWLIB}"
tar xzf ${DOWNLOAD_DIR}/${NEWLIB}
pushd newlib-${NEWLIB_VER}
patch -p1 < ${PRJ_DIR}/patches/newlib-${NEWLIB_VER}/newlib_weak.patch
patch -p1 < ${PRJ_DIR}/patches/newlib-${NEWLIB_VER}/newlib_smallmemory.patch
patch -p1 < ${PRJ_DIR}/patches/newlib-${NEWLIB_VER}/newlib_fastmem_functions.patch
popd

popd
