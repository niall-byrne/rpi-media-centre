#!/bin/bash

# pictl docker library

set -eo pipefail

_docker_compose_command() {
  # $@: The command to pass to docker compose
  # set _SERVICE_REMOVE_CONTAINERS to 1 to ensure containers are removed

  pushd "services" >> /dev/null

  docker compose "$@"

  if [[ "${_SERVICE_REMOVE_CONTAINERS}" == "1" ]]; then
    docker compose rm -f
  fi

  popd >> /dev/null
}
