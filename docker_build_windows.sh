#! /bin/bash
set -e

. configuration.sh

# This is the name of the container.
IMAGE=ghcr.io/muhkuh-sys/mbs_ubuntu_2204_x86_64:latest

# Get the project directory.
HOSTDIR=`pwd`
WORKDIR=/tmp/work

# Make sure that the "build" folder exists.
# NOTE: do not remove it, maybe there are already components.
mkdir -p ${HOSTDIR}/targets

# Start the container and mount the project folder.
CONTAINER=`docker run -t -d -v ${HOSTDIR}:${WORKDIR} ${IMAGE} /bin/bash`

# Prepare the build folder.
docker exec ${CONTAINER} /bin/bash -c "rm -rf ${BUILD_DIR}"
docker exec ${CONTAINER} /bin/bash -c "mkdir ${BUILD_DIR}"

# This is needed to install wine.
docker exec ${CONTAINER} /bin/bash -c 'dpkg --add-architecture i386'

# Update the package list to prevent "not found" messages.
docker exec ${CONTAINER} /bin/bash -c 'apt-get update --assume-yes'

# Accept the license of the msttcorefonts.
docker exec ${CONTAINER} /bin/bash -c 'echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections'

# Install the project specific packages.
docker exec ${CONTAINER} /bin/bash -c "apt-get install --assume-yes bzip2 texinfo wine zip"

# Build the linux version.
# This is necessary to get the tools to build the libraries.
docker exec ${CONTAINER} /bin/bash -c "cd ${WORKDIR} && bash ./02_clean.sh"
docker exec ${CONTAINER} /bin/bash -c "cd ${WORKDIR} && bash ./03_extract_patch.sh"
docker exec ${CONTAINER} /bin/bash -c "cd ${WORKDIR} && bash ./04_build_linux.sh"

# Build the Windows 32bit version.
docker exec ${CONTAINER} /bin/bash -c "cd ${WORKDIR} && bash ./05_build_windows32.sh"

# Build the Windows 64bit version.
docker exec ${CONTAINER} /bin/bash -c "cd ${WORKDIR} && bash ./06_build_windows64.sh"

# Create an archive.
docker exec ${CONTAINER} /bin/bash -c ". ${WORKDIR}/configuration.sh && cd ${BUILD_DIR_INSTALL_WINDOWS_X86} && zip -9 --recurse-paths ${WORKDIR}/build/${ARTIFACT_NAME}-windows-x86.zip ."
docker exec ${CONTAINER} /bin/bash -c ". ${WORKDIR}/configuration.sh && cd ${BUILD_DIR_INSTALL_WINDOWS_X86_64} && zip -9 --recurse-paths ${WORKDIR}/build/${ARTIFACT_NAME}-windows-x86_64.zip ."

# Copy the archive from the container to the host.
docker cp ${CONTAINER}:${BUILD_DIR}/${ARTIFACT_NAME}-windows-x86.tar.gz targets/
docker cp ${CONTAINER}:${BUILD_DIR}/${ARTIFACT_NAME}-windows-x86_64.tar.gz targets/

# Stop and remove the container.
docker stop ${CONTAINER}
docker rm ${CONTAINER}
