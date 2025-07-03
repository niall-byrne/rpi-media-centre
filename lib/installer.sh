#!/bin/bash

# pictl installer library

set -eo pipefail

_installer_service_backup() {
  echo "INSTALLER: Installing backup systemd service ..."

  # shellcheck disable=SC2016
  envsubst \
    '${RPI_CONTAINER_UID},${RPI_CONTAINER_GID},${RPI_ROOT}' \
    < services/backup/rpi-backup.service |
    sudo tee /etc/systemd/system/rpi-backup.service > /dev/null

  # shellcheck disable=SC2016
  envsubst \
    '${RPI_BACKUP_SCHEDULER_START_TIME},${RPI_ROOT}' \
    < services/backup/rpi-backup.timer |
    sudo tee /etc/systemd/system/rpi-backup.timer > /dev/null

  # shellcheck disable=SC2016
  envsubst \
    '${RPI_BACKUP_SCHEDULING_HOUR},${RPI_CONTAINER_USERNAME}' \
    < services/backup/crontab |
    sudo tee /etc/cron.d/rpi-backups > /dev/null

  sudo systemctl daemon-reload
  sudo systemctl enable rpi-backup.timer

  echo "INSTALLER: Service backup systemd service installed!"
}

_installer_service_shim() {
  echo "INSTALLER: Installing service shim ..."
  export RPI_WORKING_DIRECTORY
  # shellcheck disable=SC2016
  envsubst \
    '${RPI_WORKING_DIRECTORY}' < services/cli/shim.sh |
    sudo tee /usr/local/bin/pictl > /dev/null
  sudo chown "${USER}":"${USER}" /usr/local/bin/pictl
  sudo chmod 500 /usr/local/bin/pictl
  echo "INSTALLER: Service shim installed!"
}
