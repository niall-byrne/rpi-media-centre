#!/bin/bash

set -eo pipefail

_testing_build() {
  pushd "${TEST_WORKING_DIRECTORY}" > /dev/null

  docker build \
    --build-arg UID1="$(id -u)" \
    --build-arg GID1="$(id -u)" \
    -f testing/Dockerfile \
    -t rpi-media-centre:test \
    .

  popd > /dev/null
}

_testing_run() {
  pushd "${TEST_WORKING_DIRECTORY}" > /dev/null

  if [[ "${TEST_CONTAINER_DISABLE_TTY}" -eq "1" ]]; then
    TEST_CONTAINER_SWITCHES="t"
  fi

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
    "${TEST_CONTAINER_COMMAND}" "${@}"

  popd > /dev/null
}

main() {
  local TEST_CONTAINER_COMMAND="${2:-bash}"
  local TEST_CONTAINER_SWITCHES="it"
  local TEST_CONTAINER_DISABLE_TTY="${TEST_CONTAINER_DISABLE_TTY:0}"
  local TEST_WORKING_DIRECTORY

  if [[ "${EUID}" == "0" ]]; then
    echo "Do not run this container as root."
    echo "Try one of the following strategies:"
    echo "#1 add yourself to the docker group, and retry:"
    echo "- sudo usermod -aG docker \$USER"
    echo "- exec sudo su -l \$USER"
    echo "#2 change the permissions on the docker socket:"
    echo "- ./testing/container.sh fix_docker"
    return 127
  fi

  TEST_WORKING_DIRECTORY="$(dirname "${0}")/.."

  case "${1}" in
    build)
      _testing_build
      ;;
    ci)
      TEST_CONTAINER_SWITCHES="t"
      _testing_build
      _testing_run t
      ;;
    docker_permissions)
      sudo chgrp "${USER}" /var/run/docker.sock
      ;;
    run)
      _testing_run "${@:2}"
      ;;
    *)
      echo "Valid commands:"
      echo "- build"
      echo "- docker_permissions"
      echo "- run"
      return 127
      ;;
  esac
}

main "$@"
