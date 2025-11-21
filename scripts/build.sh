#!/usr/bin/env bash
set -e

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

export $(grep -v '^#' $SCRIPTPATH/../.env | xargs)

docker run -it --rm --cap-add=SYS_ADMIN --privileged \
  -v $(pwd)/build:/build/out \
  -v $(pwd)/scripts:/build/scripts \
  node /build/scripts/create.sh

exit

