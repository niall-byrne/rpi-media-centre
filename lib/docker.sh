#!/bin/bash

# pictl docker library

set -eo pipefail

_docker_compose_command() {
  # $@: the command to pass to docker compose
  # set _RPI_SERVICE_REMOVE_CONTAINERS to 1 to ensure containers are removed

  local service
  local selected_services=()
  local remove_containers="${_RPI_SERVICE_REMOVE_CONTAINERS:-"0"}"

  _dependencies_group_containers

  for service in "${RPI_SERVICES[@]}"; do
    selected_services+=("--profile")
    selected_services+=("${service}")
  done

  pushd "services" >> /dev/null

  docker compose "${selected_services[@]}" "$@"

  if [[ "${remove_containers}" == "1" ]]; then
    docker compose "${selected_services[@]}" rm -f
  fi

  popd >> /dev/null
}

_docker_compose_filtered_env() {
  # $1: the variable prefix to filter
  # $2: the path to save as

  declare -p |
    grep "^declare -. ${1}" |
    sed 's/^declare -. //g' \
      > "${2}" || true

  stdlib.security.path.secure "${2}" "root" "root" "600"

  RPI_EXIT_CLEANUP_PATHS+=("${2}")
}

_docker_compose_exec() {
  # $@: the command to pass to docker compose run

  local service="${1}"

  _dependencies_group_containers

  shift

  pushd "services" >> /dev/null

  docker compose exec "${service}" "$@"

  popd >> /dev/null
}
