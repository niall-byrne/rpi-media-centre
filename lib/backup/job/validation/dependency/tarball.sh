#!/bin/bash

# pictl backup job validation dependency tarball library

set -eo pipefail

_backup_job_validation_dependency_tarball() {
  if [[ -n "${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}" ]]; then
    _dependencies_group_backups_rsync
  fi
}
