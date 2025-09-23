#!/bin/bash

# pictl backup job validation keyfile library

set -eo pipefail

_backup_job_validation_filesystem_keyfile() {
  if [[ -n "${RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH}" ]]; then
    _backup_job_validation_filesystem_keyfile_is_secure ||
      _backup_job_validation_error "Invalid encryption key path." \
        _backup_job_message_keyfile_path
  fi
}

_backup_job_validation_filesystem_keyfile_is_secure() {
  # $1: the path to check

  stdlib.io.path.assert.is_file "${RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH}"
  stdlib.security.path.assert.is_secure "${RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH}" \
    "root" \
    "root" \
    "400"
}
