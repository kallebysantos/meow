#!/usr/bin/env bash
set -e

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

export $(grep -v '^#' $SCRIPTPATH/../.env | xargs)

ARCH=aarch64
FIRECRACKER_VERSION=v1.13.1
DONWLOAD_FILE=

curl -s -L https://github.com/firecracker-microvm/firecracker/releases/download/$FIRECRACKER_VERSION/firecracker-${FIRECRACKER_VERSION}-${ARCH}.tgz | tar zxv

mkdir -p ./temp
mv "release-${FIRECRACKER_VERSION}-${ARCH}" "./temp/${DONWLOAD_FILE}"
