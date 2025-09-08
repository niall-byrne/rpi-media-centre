#!/bin/bash

set -eo pipefail

TEST_WORKING_DIRECTORY="$(dirname "${0}")/.."

main() {
  local TEST_CONTAINER_COMMAND="${1:-bash}"
  local TEST_CONTAINER_SWITCHES="it"
  local TEST_CONTAINER_CI="${TEST_CONTAINER_CI:0}"

  if [[ "${TEST_CONTAINER_CI}" -eq "1" ]]; then
    TEST_CONTAINER_SWITCHES="t"
  fi

  pushd "${TEST_WORKING_DIRECTORY}" > /dev/null

  docker build \
    --build-arg UID1="$(id -u)" \
    --build-arg GID1="$(id -u)" \
    -f testing/Dockerfile \
    -t rpi-media-centre:test \
    .

  docker run \
    --rm \
    -"${TEST_CONTAINER_SWITCHES}" \
    -v "${PWD}/.rpi":/etc/rpi \
    -v "${PWD}":/rpi-media-centre \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "${HOME}"/.ssh:/home/pi1/.ssh \
    -v "${HOME}"/.gitconfig:/home/pi1/.gitconfig \
    -v "${HOME}"/.gitconfig_global:/home/pi1/.gitconfig_global \
    -v "${HOME}"/.gitignore_global:/home/pi1/.gitignore_global \
    --tmpfs /tmp:exec \
    rpi-media-centre:test \
    "${TEST_CONTAINER_COMMAND}" "${@:2}"

  popd > /dev/null
}

main "$@"
