#!/bin/bash

# pictl backup job task tarball library

set -eo pipefail

_backup_job_task_tarball() {
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FILENAME

  if [[ -n "${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}" ]]; then
    _backup_job_task_wrapper "_backup_job_task_tarball_filesystem"
  else
    echo " -- BACKUP JOB: No tarball required for this job !"
  fi
}

_backup_job_task_tarball_filesystem() {
  _control_pushd "$(dirname "${RPI_BACKUP_JOB_LOCAL_SOURCE}")" "_backup_job_task_tarball_filesystem_build"
  _backup_job_task_tarball_filesystem_prune
}

_backup_job_task_tarball_filesystem_build() {
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FILENAME

  RPI_BACKUP_JOB_LOCAL_TARBALL_FILENAME="$(_backup_job_task_tarball_get_new_filename)"
  echo " -- BACKUP JOB: Creating tarball '${RPI_BACKUP_JOB_LOCAL_TARBALL_FILENAME}' ..."
  sudo tar cf "${RPI_BACKUP_JOB_LOCAL_TARBALL_FILENAME}" "$(basename "${RPI_BACKUP_JOB_LOCAL_SOURCE}")"
  sudo chmod "600" "$(basename "${RPI_BACKUP_JOB_LOCAL_SOURCE}")"
  sudo chown "${RPI_CONTAINER_UID}":"${RPI_CONTAINER_GID}" "$(basename "${RPI_BACKUP_JOB_LOCAL_SOURCE}")"
}

_backup_job_task_tarball_filesystem_prune() {
  local RPI_BACKUP_JOB_PRUNE_INDEX

  echo " -- BACKUP JOB: Restricting storage to '${RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS}' tarball version(s) ... "

  ((RPI_BACKUP_JOB_PRUNE_INDEX = RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS + 1))

  # shellcheck disable=SC2012
  ls -t1 "${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}/${RPI_BACKUP_JOB_NAME}_"[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]_[0-9][0-9]-[0-9][0-9]-[0-9][0-9].tar |
    tail -n +${RPI_BACKUP_JOB_PRUNE_INDEX} |
    tr \\n \\0 |
    xargs -0 rm -f
}

_backup_job_task_tarball_get_new_filename() {
  echo "${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}/${RPI_BACKUP_JOB_NAME}_$(date +%Y-%m-%d_%H-%M-%S).tar"
}

_backup_job_task_tarball_get_latest_filename() {
  # shellcheck disable=SC2012
  ls -t1 "${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}/${RPI_BACKUP_JOB_NAME}_"* |
    head -n1
}
