#!/bin/bash

# pictl backup job log library

set -eo pipefail

_backup_job_log() {
  echo "  RPI_BACKUP_JOB_NAME='${RPI_BACKUP_JOB_NAME}'"
  if [[ -n "${RPI_BACKUP_JOB_GROUP}" ]]; then
    echo "  RPI_BACKUP_JOB_GROUP='${RPI_BACKUP_JOB_GROUP}'"
  fi

  echo "  RPI_BACKUP_JOB_LOCAL_SOURCE='${RPI_BACKUP_JOB_LOCAL_SOURCE}'"
  _backup_job_log_folder_and_permission "RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER" "RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER_PERMISSION"
  _backup_job_log_folder_and_permission "RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER" "RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER_PERMISSION"
  echo "  RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS='${RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS}'"
  echo "  RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH='${RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH}'"
  echo "  RPI_BACKUP_JOB_REMOTE_TARGET='${RPI_BACKUP_JOB_REMOTE_TARGET}'"
  echo "  RPI_BACKUP_JOB_REMOTE_PARAMETER='${RPI_BACKUP_JOB_REMOTE_PARAMETER}'"

  if [[ -n "${RPI_BACKUP_JOB_QUEUE}" ]]; then
    echo "  RPI_BACKUP_JOB_QUEUE='${RPI_BACKUP_JOB_QUEUE}'"
  fi
}

_backup_job_log_folder_and_permission() {
  # $1: the folder variable
  # $2: the permission variable

  if [[ -n "${!2}" ]]; then
    echo "  ${1}='${!1}:${!2}'"
  else
    echo "  ${1}='${!1}'"
  fi
}
