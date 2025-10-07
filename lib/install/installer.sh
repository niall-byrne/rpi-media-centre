#!/bin/bash

# pictl install library

set -eo pipefail

export RPI_REPOSITORY_LOCATION="/var/local/rpi"

RPI_INSTALLER_CRON_FILE_PATH="/etc/cron.d/rpi-backups"
RPI_INSTALLER_REPOSITORY_SOURCE="https://github.com/niall-byrne/rpi-media-centre.git"
RPI_INSTALLER_SHIM_PATH="/usr/local/sbin/pictl"
RPI_INSTALLER_SYSTEMD_SERVICE_PATH="/etc/systemd/system/rpi-backup.service"
RPI_INSTALLER_SYSTEMD_TIMER_PATH="/etc/systemd/system/rpi-backup.timer"

_installer() {
  # @1: the install args

  _installer_service_repository "$@"
  _installer_service_shim
  _installer_service_backup
}

_installer_service_backup() {
  _cli_log_warning "INSTALLER: Installing backup systemd service ..."

  # shellcheck disable=SC2016
  envsubst '${RPI_SVC_GROUPNAME},${RPI_SVC_USERNAME},${RPI_ROOT}' \
    < services/backup/rpi-backup.service \
    > "${RPI_INSTALLER_SYSTEMD_SERVICE_PATH}"

  # shellcheck disable=SC2016
  envsubst '${RPI_BACKUP_SCHEDULER_START_TIME},${RPI_ROOT}' \
    < services/backup/rpi-backup.timer \
    > "${RPI_INSTALLER_SYSTEMD_TIMER_PATH}"

  # shellcheck disable=SC2016
  envsubst '${RPI_BACKUP_SCHEDULING_HOUR},${RPI_SVC_USERNAME}' \
    < services/backup/crontab \
    > "${RPI_INSTALLER_CRON_FILE_PATH}"

  systemctl daemon-reload
  systemctl enable rpi-backup.timer

  _cli_log_success "INSTALLER: Service backup systemd service installed!"
}

_installer_service_repository() {
  # $1: sha, branch or tag

  local RPI_REPOSITORY_SHA="${1:-"origin/main"}"

  _cli_log_warning "INSTALLER: Installing repository to ${RPI_REPOSITORY_LOCATION} ..."

  stdlib.security.path.make.dir "${RPI_REPOSITORY_LOCATION}" "${RPI_SVC_USERNAME}" "${RPI_SVC_GROUPNAME}" "700"

  if stdlib.io.path.query.is_folder "${RPI_REPOSITORY_LOCATION}/source/.git"; then
    sudo chown "${RPI_SVC_USERNAME}":"${RPI_SVC_GROUPNAME}" -R "${RPI_REPOSITORY_LOCATION}/source"
    # KCOV_EXCLUDE_BEGIN
    sudo -u "${RPI_SVC_USERNAME}" bash -c "
      cd '${RPI_REPOSITORY_LOCATION}/source' &&
      git fetch &&
      git reset --hard '${RPI_REPOSITORY_SHA}'
    "
    # KCOV_EXCLUDE_END
    rm -f "${RPI_REPOSITORY_LOCATION}/source/${RPI_PATH_COMPILED_ROOT}/"*
  else
    # KCOV_EXCLUDE_BEGIN
    sudo -u "${RPI_SVC_USERNAME}" bash -c "
      cd '${RPI_REPOSITORY_LOCATION}' &&
      git clone '${RPI_INSTALLER_REPOSITORY_SOURCE}' 'source' &&
      cd 'source' &&
      git reset --hard '${RPI_REPOSITORY_SHA}'
    "
    # KCOV_EXCLUDE_END
  fi

  _cli_log_success "INSTALLER: Repository has been installed to ${RPI_REPOSITORY_LOCATION} !"
}

_installer_service_shim() {
  _cli_log_warning "INSTALLER: Installing service shim ..."

  # shellcheck disable=SC2016
  envsubst '${RPI_REPOSITORY_LOCATION}' < services/cli/shim.sh \
    > "${RPI_INSTALLER_SHIM_PATH}"

  stdlib.security.path.secure "${RPI_INSTALLER_SHIM_PATH}" "root" "root" "755"

  _cli_log_success "INSTALLER: Service shim installed!"
}
