#!/bin/bash

# pictl backup job validation dependency rsync library

set -eo pipefail

_backup_job_validation_dependency_rsync() {
  if [[ -n "${RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER}" ]]; then
    _dependencies_group_backups_rsync
  fi
}
