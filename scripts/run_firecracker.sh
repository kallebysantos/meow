#!/usr/bin/env bash
set -e

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

export $(grep -v '^#' $SCRIPTPATH/../.env | xargs)

API_SOCKET="/tmp/firecracker.socket"

sudo rm -f $API_SOCKET

sudo ./temp/release-v1.13.1-aarch64/firecracker-v1.13.1-aarch64 --api-sock "${API_SOCKET}" --enable-pci
