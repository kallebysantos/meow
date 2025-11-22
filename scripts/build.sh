#!/usr/bin/env bash
set -e

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

export $(grep -v '^#' $SCRIPTPATH/../.env | xargs)

docker build -f ./Dockerfile.builder -t meow-builder:latest .

docker run -i --rm --cap-add=SYS_ADMIN --privileged \
  -v "$(pwd)/build:/builder/out" \
  -v "$(pwd)/environments/${1}:/builder/workdir:ro" \
  meow-builder:latest "$(cat environments/$1/Meowfile)"

exit
