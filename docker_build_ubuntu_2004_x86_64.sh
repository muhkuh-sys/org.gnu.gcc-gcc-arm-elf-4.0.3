#! /bin/bash
set -e

. configuration.sh

# This is the name of the container.
IMAGE=ghcr.io/muhkuh-sys/mbs_ubuntu_2004_x86_64:latest

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

# Update the package list to prevent "not found" messages.
docker exec ${CONTAINER} /bin/bash -c 'apt-get update --assume-yes'

# Install the project specific packages.
docker exec ${CONTAINER} /bin/bash -c "apt-get install --assume-yes bzip2 texinfo"

# Build the linux version.
docker exec ${CONTAINER} /bin/bash -c "cd ${WORKDIR} && bash ./02_clean.sh"
docker exec ${CONTAINER} /bin/bash -c "cd ${WORKDIR} && bash ./03_extract_patch.sh"
docker exec ${CONTAINER} /bin/bash -c "cd ${WORKDIR} && bash ./04_build_linux.sh"

# Create an archive.
docker exec ${CONTAINER} /bin/bash -c ". ${WORKDIR}/configuration.sh && tar --create --file ${BUILD_DIR}/${ARTIFACT_NAME}-ubuntu_2004-x86_64.tar.gz --gzip --directory ${BUILD_DIR_INSTALL_LINUX} ."
# Copy the archive from the container to the host.
docker cp ${CONTAINER}:${BUILD_DIR}/${ARTIFACT_NAME}-ubuntu_2004-x86_64.tar.gz targets/

# Stop and remove the container.
docker stop ${CONTAINER}
docker rm ${CONTAINER}
