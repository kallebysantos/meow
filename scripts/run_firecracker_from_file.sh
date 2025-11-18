#!/usr/bin/env bash
set -e

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

export $(grep -v '^#' $SCRIPTPATH/../.env | xargs)

API_SOCKET="/tmp/firecracker.socket"

sudo rm -f $API_SOCKET

sudo ./temp/release-v1.13.1-x86_64/firecracker-v1.13.1-x86_64  --api-sock /tmp/firecracker.socket --config-file ./vm_config.json
