#!/bin/bash

# pictl backup job validation source library

set -eo pipefail

_backup_job_validation_filesystem_source() {
  # $1: the function to call on validation failure

  _backup_job_validation_filesystem_source_path "${RPI_BACKUP_JOB_LOCAL_SOURCE}" ||
    _backup_job_validation_error "Invalid source path." \
      _backup_job_message_source_path
}
