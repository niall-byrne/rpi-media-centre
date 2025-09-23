#!/bin/bash

# pictl backup job parse library

set -eo pipefail

_backup_job_parse_destination_folders() {
  _backup_job_parse_destination_folder_and_permission "${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}" \
    RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER \
    RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER_PERMISSION

  _backup_job_parse_destination_folder_and_permission "${RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER}" \
    RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER \
    RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER_PERMISSION
}

_backup_job_parse_destination_folder_and_permission() {
  # $1: the combined path string
  # $2: the path variable to set
  # #3: the permission variable to set

  local folder_permission_pair=()

  stdlib.array.make.from_string folder_permission_pair ":" "${1}"
  if [[ "${#folder_permission_pair[@]}" == "2" ]]; then
    printf -v "${2}" "%s" "${folder_permission_pair[0]}"
    printf -v "${3}" "%s" "${folder_permission_pair[1]}"
  fi
}
