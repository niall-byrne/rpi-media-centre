#!/bin/bash

# pictl backup job task rsync library

set -eo pipefail

_backup_job_task_rsync() {
  if [[ -n "${RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER}" ]]; then
    _backup_job_task_wrapper "_backup_job_task_rsync_filesystem"
  else
    echo " -- BACKUP JOB: No rsync required for this job !"
  fi
}

_backup_job_task_rsync_filesystem() {
  local RPI_BACKUP_JOB_LOCAL_RSYNC_TARGET

  echo " -- BACKUP JOB: Copying '${RPI_BACKUP_JOB_LOCAL_SOURCE}' with rsync ..."
  RPI_BACKUP_JOB_LOCAL_RSYNC_TARGET="${RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER}/$(basename "${RPI_BACKUP_JOB_LOCAL_SOURCE}")-rsync-backup"
  mkdir -p "${RPI_BACKUP_JOB_LOCAL_RSYNC_TARGET}"
  rsync -a --delete "${RPI_BACKUP_JOB_LOCAL_SOURCE}" "${RPI_BACKUP_JOB_LOCAL_RSYNC_TARGET}/"

}
