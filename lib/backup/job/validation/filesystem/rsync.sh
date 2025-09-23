#!/bin/bash

# pictl backup job validation rsync library

set -eo pipefail

_backup_job_validation_filesystem_rsync() {
  if [[ -n "${RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER}" ]]; then
    _backup_job_validation_filesystem_destination_path "${RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER}" \
      "${RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER_PERMISSION}" ||
      _backup_job_validation_error "Invalid rsync destination path." \
        _backup_job_message_destination_path
  fi
}
