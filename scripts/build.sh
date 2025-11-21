#!/usr/bin/env bash
set -e

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

export $(grep -v '^#' $SCRIPTPATH/../.env | xargs)

docker run -i --rm --cap-add=SYS_ADMIN --privileged \
  -v $(pwd)/build:/build/out \
  -v $(pwd)/scripts:/build/scripts \
  node /bin/sh <scripts/create.sh

exit

