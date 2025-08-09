#!/bin/bash

# pictl installer library

set -eo pipefail

export RPI_REPOSITORY_LOCATION="/var/local/rpi"

_installer() {
  # @1: the installer args

  _installer_service_repository "$@"
  _installer_service_shim
  _installer_service_backup
}

_installer_service_backup() {
  _cli_log_warning "INSTALLER: Installing backup systemd service ..."

  # shellcheck disable=SC2016
  envsubst \
    '${RPI_SVC_GROUPNAME},${RPI_SVC_USERNAME},${RPI_ROOT}' \
    < services/backup/rpi-backup.service \
    > /etc/systemd/system/rpi-backup.service

  # shellcheck disable=SC2016
  envsubst \
    '${RPI_BACKUP_SCHEDULER_START_TIME},${RPI_ROOT}' \
    < services/backup/rpi-backup.timer \
    > /etc/systemd/system/rpi-backup.timer

  # shellcheck disable=SC2016
  envsubst \
    '${RPI_BACKUP_SCHEDULING_HOUR},${RPI_SVC_USERNAME}' \
    < services/backup/crontab \
    > /etc/cron.d/rpi-backups

  systemctl daemon-reload
  systemctl enable rpi-backup.timer

  _cli_log_success "INSTALLER: Service backup systemd service installed!"
}

_installer_service_repository() {
  # $1: sha, branch or tag

  local RPI_REPOSITORY_SHA="${1:-"origin/main"}"
  local RPI_REPOSITORY_SOURCE="https://github.com/niall-byrne/rpi-media-centre.git"

  _cli_log_warning "INSTALLER: Installing repository to ${RPI_REPOSITORY_LOCATION} ..."

  _security_path_mkdir "${RPI_REPOSITORY_LOCATION}" "${RPI_SVC_USERNAME}" "${RPI_SVC_GROUPNAME}" "700"

  if [[ -d "${RPI_REPOSITORY_LOCATION}/source/.git" ]]; then
    sudo chown "${RPI_SVC_USERNAME}":"${RPI_SVC_GROUPNAME}" -R "${RPI_REPOSITORY_LOCATION}/source"
    sudo -u "${RPI_SVC_USERNAME}" bash -c "
      cd '${RPI_REPOSITORY_LOCATION}/source' &&
      git fetch &&
      git reset --hard '${RPI_REPOSITORY_SHA}'
    "
    rm -f "${RPI_REPOSITORY_LOCATION}/source/${RPI_PATH_COMPILED_ROOT}/"*
  else
    sudo -u "${RPI_SVC_USERNAME}" bash -c "
      cd '${RPI_REPOSITORY_LOCATION}' &&
      git clone '${RPI_REPOSITORY_SOURCE}' 'source' &&
      cd 'source' &&
      git reset --hard '${RPI_REPOSITORY_SHA}'
    "
  fi

  _cli_log_success "INSTALLER: Repository has been installed to ${RPI_REPOSITORY_LOCATION} !"
}

_installer_service_shim() {
  _cli_log_warning "INSTALLER: Installing service shim ..."

  # shellcheck disable=SC2016
  envsubst \
    '${RPI_REPOSITORY_LOCATION}' < services/cli/shim.sh \
    > /usr/local/sbin/pictl

  _security_path_secure /usr/local/sbin/pictl "root" "root" "755"

  _cli_log_success "INSTALLER: Service shim installed!"
}
