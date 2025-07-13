#!/bin/bash

set -eo pipefail

TEST_WORKING_DIRECTORY="$(dirname "${0}")/.."

main() {
  pushd "${TEST_WORKING_DIRECTORY}" > /dev/null

  docker build \
    --build-arg UID1="$(id -u)" \
    --build-arg GID1="$(id -u)" \
    -f testing/Dockerfile \
    -t rpi-media-centre:test \
    .

  docker run \
    --rm \
    -it \
    -v "${PWD}/.rpi":/etc/rpi \
    -v "${PWD}":/home/pi1/rpi-media-centre \
    -v /var/run/docker.sock:/var/run/docker.sock \
    rpi-media-centre:test \
    bash

  popd > /dev/null
}

main
