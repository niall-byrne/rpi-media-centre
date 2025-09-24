#!/bin/bash

# pictl backup job validation tarball library

set -eo pipefail

_backup_job_validation_filesystem_tarball() {
  if [[ -n "${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}" ]]; then
    _backup_job_validation_filesystem_destination_path \
      "${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}" \
      "${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER_PERMISSION}" ||
      _backup_job_validation_error "Invalid tarball destination path." \
        _backup_job_message_destination_path
  fi
}
