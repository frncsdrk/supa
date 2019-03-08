#!/usr/bin/env bash
#
# build script for docker image

IMAGE_NAME="supa.sh"

docker build -t "${IMAGE_NAME}" . "$@"
