#!/bin/bash
set -e

. ./configuration.sh

############################
# Create directory structure
############################
rm -rf ${BUILD_DIR_BUILD}
rm -rf ${BUILD_DIR_SRC}
rm -rf ${BUILD_DIR_INSTALL}

