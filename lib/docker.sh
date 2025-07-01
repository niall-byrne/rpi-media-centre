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

_docker_compose_command() {
  # $@: the command to pass to docker compose
  # set _SERVICE_REMOVE_CONTAINERS to 1 to ensure containers are removed

  local SERVICE
  SELECTED_SERVICES=()

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

  shift

  pushd "services" >> /dev/null

  docker compose exec "${SERVICE}" "$@"

  popd >> /dev/null
}

_docker_secure_bind_mounts() {
  if _is_service_selected "plex"; then
    chmod 700 "${RPI_PLEX_PATH_CONFIG}"
    chmod 700 "${RPI_PLEX_PATH_TRANSCODE}"
  fi
  if _is_service_selected "samba"; then
    chmod 700 "${RPI_SAMBA_PATH_CONFIG}"
  fi
  if _is_service_selected "syncthing"; then
    chmod 700 "${RPI_SYNCTHING_PATH_CONFIG}"
  fi
}
