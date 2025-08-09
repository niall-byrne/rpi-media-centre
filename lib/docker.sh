#!/bin/bash

# pictl docker library

set -eo pipefail

_is_service_selected() {
  # $1: the service to check for selection

  local SERVICE

  for SERVICE in "${RPI_SERVICES[@]}"; do
    if [[ "${SERVICE}" == "${1}" ]]; then
      return 0
    fi
  done

  return 1
}

_docker_create_filtered_env() {
  # $1: the variable prefix to filter
  # $2: the path to save as

  declare -p |
    grep "^declare -. ${1}" |
    sed 's/^declare -. //g' \
      > "${2}" || true

  _security_path_secure "${2}" "root" "root" "600"

  RPI_EXIT_CLEANUP_PATHS+=("${2}")
}

_docker_compose_command() {
  # $@: the command to pass to docker compose
  # set _SERVICE_REMOVE_CONTAINERS to 1 to ensure containers are removed

  local SERVICE
  local SELECTED_SERVICES=()

  _dependencies_group_containers

  for SERVICE in "${RPI_SERVICES[@]}"; do
    SELECTED_SERVICES+=("--profile")
    SELECTED_SERVICES+=("${SERVICE}")
  done
  pushd "services" >> /dev/null

  docker compose "${SELECTED_SERVICES[@]}" "$@"

  if [[ "${_SERVICE_REMOVE_CONTAINERS}" == "1" ]]; then
    docker compose "${SELECTED_SERVICES[@]}" rm -f
  fi

  popd >> /dev/null
}

_docker_compose_exec() {
  # $@: the command to pass to docker compose run

  local SERVICE="${1}"

  _dependencies_group_containers

  shift

  pushd "services" >> /dev/null

  docker compose exec "${SERVICE}" "$@"

  popd >> /dev/null
}
