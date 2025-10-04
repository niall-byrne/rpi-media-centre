#!/bin/bash

# pictl service cli library

set -eo pipefail

_service_cli_kill() {
  local _RPI_SERVICE_REMOVE_CONTAINERS=1

  _cli_log_warning "Media centre now being killed ..."

  _docker_compose_command kill
  _disk_manifest_command_unmount
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
  _disk_manifest_command_mount
  _disk_initialize_mounts

  _service_config "pihole" "samba"

  _docker_compose_command up -d

  _service_config "syncthing"
}

_service_cli_status() {
  local _RPI_SERVICE_REMOVE_CONTAINERS=0

  _docker_compose_command ps -a
}

_service_cli_stop() {
  local _RPI_SERVICE_REMOVE_CONTAINERS=1

  _cli_log_warning "Media centre now stopping ..."

  _docker_compose_command stop
  _disk_manifest_command_unmount
}

_service_cli_upgrade() {
  local _RPI_SERVICE_REMOVE_CONTAINERS=1

  _cli_log_warning "Media centre now being upgraded ..."

  _docker_compose_command stop
  _docker_compose_command pull
  _service_cli_start
}
