#!/bin/bash

# pictl service cli library

set -eo pipefail

_service_cli_kill() {
  local _RPI_SERVICE_REMOVE_CONTAINERS=1

  _cli_log_warning "Media centre now being killed ..."

  _docker_compose_command kill
  _disk_manifest_unmount_all
}

_service_cli_logs() {
  local _RPI_SERVICE_REMOVE_CONTAINERS=0

  _docker_compose_command logs -f
}

_service_cli_pause() {
  local _RPI_SERVICE_REMOVE_CONTAINERS=0

  _cli_log_warning "Media centre now being paused ..."

  _docker_compose_command stop
}

_service_cli_resume() {
  local _RPI_SERVICE_REMOVE_CONTAINERS=0

  _is_disk_mounted_all

  _cli_log_warning "Media centre now being resumed ..."
  _docker_compose_command start
}

_service_cli_start() {
  local _RPI_SERVICE_REMOVE_CONTAINERS=0

  _cli_log_warning "Media centre now starting ..."
  _disk_manifest_mount_all
  _disk_initialize_mounts

  if _service_query_is_selected "pihole"; then
    _configuration_pihole
  fi

  if _service_query_is_selected "samba"; then
    _configuration_samba
  fi

  _docker_compose_command up -d

  if _service_query_is_selected "syncthing"; then
    _configuration_syncthing
  fi
}

_service_cli_status() {
  local _RPI_SERVICE_REMOVE_CONTAINERS=0

  _docker_compose_command ps -a
}

_service_cli_stop() {
  local _RPI_SERVICE_REMOVE_CONTAINERS=1

  _cli_log_warning "Media centre now stopping ..."

  _docker_compose_command stop
  _disk_manifest_unmount_all
}

_service_cli_upgrade() {
  local _RPI_SERVICE_REMOVE_CONTAINERS=1

  _cli_log_warning "Media centre now being upgraded ..."

  _docker_compose_command stop
  _docker_compose_command pull
  _service_cli_start
}
