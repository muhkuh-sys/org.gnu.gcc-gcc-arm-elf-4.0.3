# This is the common configuration file for all command scripts.

PACKAGE_VERSION="1"

GCC_VER="4.0.4"
GCC="gcc-$GCC_VER.tar.bz2"
GCC_URL="ftp://ftp.gwdg.de/pub/misc/gcc/releases/gcc-$GCC_VER/$GCC"

BINUTILS_VER="2.21.1"
BINUTILS="binutils-${BINUTILS_VER}a.tar.bz2"
BINUTILS_URL="http://ftp.gnu.org/gnu/binutils/$BINUTILS"

NEWLIB_VER="1.19.0"
NEWLIB="newlib-$NEWLIB_VER.tar.gz"
NEWLIB_URL="ftp://sourceware.org/pub/newlib/$NEWLIB"

ARM_TARGET="arm-elf"

PRJ_DIR=`pwd`
DOWNLOAD_DIR=${PRJ_DIR}/download

BUILD_DIR=/tmp/build
BUILD_DIR_BUILD=${BUILD_DIR}/build
BUILD_DIR_SRC=${BUILD_DIR}/src
BUILD_DIR_INSTALL=${BUILD_DIR}/install

BUILD_DIR_INSTALL_LINUX=${BUILD_DIR_INSTALL}/linux
BUILD_DIR_INSTALL_WINDOWS_X86=${BUILD_DIR_INSTALL}/windows_x86
BUILD_DIR_INSTALL_WINDOWS_X86_64=${BUILD_DIR_INSTALL}/windows_x86_64

# All builds have a common LIB_PREFIX.
LIB_PREFIX="${BUILD_DIR_INSTALL_LINUX}/tmp"

LINUX_PREFIX="${BUILD_DIR_INSTALL_LINUX}/${ARM_TARGET}-gcc-$GCC_VER"
WINDOWS_X86_PREFIX="${BUILD_DIR_INSTALL_WINDOWS_X86}/${ARM_TARGET}-gcc-$GCC_VER"
WINDOWS_X86_64_PREFIX="${BUILD_DIR_INSTALL_WINDOWS_X86_64}/${ARM_TARGET}-gcc-$GCC_VER"

ARTIFACT_NAME="gcc-${ARM_TARGET}-${GCC_VER}.${PACKAGE_VERSION}"

# Create the build dir if it does not exist.
mkdir -p ${BUILD_DIR}
