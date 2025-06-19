#!/bin/bash

set -eo pipefail

TEST_WORKING_DIRECTORY="$(dirname "${0}")/.."

main() {
  pushd "${TEST_WORKING_DIRECTORY}" > /dev/null

  docker build -f testing/Dockerfile -t rpi-media-centre:test .
  docker run --rm -it -v "${PWD}":/mnt -v /var/run/docker.sock:/var/run/docker.sock rpi-media-centre:test bash

  popd > /dev/null
}

main
