#!/bin/bash
set -e

. ./configuration.sh

#####################################
# Download all needed files
#####################################

# Create the download dir if it does not exist yet.
mkdir -p ${BUILD_DIR_DOWNLOAD}

# Download all files.
pushd ${BUILD_DIR_DOWNLOAD}
wget -c $GCC_URL
wget -c $BINUTILS_URL
wget -c $NEWLIB_URL
popd
