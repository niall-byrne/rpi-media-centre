#!/bin/bash

# pictl backup manifest command all library

set -eo pipefail

_backup_manifest_command_all() {
  # $1: the command to execute on all jobs
  # $2: an optional group to filter jobs by
  # $3: an optional name to filter jobs by

  local RPI_BACKUP_JOBS_INDEX
  local RPI_BACKUP_JOBS_NAMES=()
  local RPI_BACKUP_JOBS_GROUPS=()
  local RPI_BACKUP_JOBS_LOCAL_SOURCES=()
  local RPI_BACKUP_JOBS_LOCAL_RSYNC_FOLDERS=()
  local RPI_BACKUP_JOBS_LOCAL_TARBALL_FOLDERS=()
  local RPI_BACKUP_JOBS_LOCAL_TARBALL_VERSIONS=()
  local RPI_BACKUP_JOBS_REMOTE_ENCRYPTION_KEY_PATHS=()
  local RPI_BACKUP_JOBS_REMOTE_TARGETS=()
  local RPI_BACKUP_JOBS_REMOTE_PARAMETERS=()

  _backup_manifest_load

  for ((RPI_BACKUP_JOBS_INDEX = 0; RPI_BACKUP_JOBS_INDEX < "${#RPI_BACKUP_JOBS_NAMES[@]}"; RPI_BACKUP_JOBS_INDEX++)); do

    if [[ -n "${2}" ]] &&
      [[ "${2}" != "${RPI_BACKUP_JOBS_GROUPS[RPI_BACKUP_JOBS_INDEX]}" ]]; then
      continue
    fi

    if [[ -n "${3}" ]] &&
      [[ "${3}" != "${RPI_BACKUP_JOBS_NAMES[RPI_BACKUP_JOBS_INDEX]}" ]]; then
      continue
    fi

    __backup_manifest_command_all_wrapper "${1}" \
      "${RPI_BACKUP_JOBS_NAMES[RPI_BACKUP_JOBS_INDEX]}" \
      "${RPI_BACKUP_JOBS_GROUPS[RPI_BACKUP_JOBS_INDEX]}" \
      "${RPI_BACKUP_JOBS_LOCAL_SOURCES[RPI_BACKUP_JOBS_INDEX]}" \
      "${RPI_BACKUP_JOBS_LOCAL_RSYNC_FOLDERS[RPI_BACKUP_JOBS_INDEX]}" \
      "${RPI_BACKUP_JOBS_LOCAL_TARBALL_FOLDERS[RPI_BACKUP_JOBS_INDEX]}" \
      "${RPI_BACKUP_JOBS_LOCAL_TARBALL_VERSIONS[RPI_BACKUP_JOBS_INDEX]}" \
      "${RPI_BACKUP_JOBS_REMOTE_ENCRYPTION_KEY_PATHS[RPI_BACKUP_JOBS_INDEX]}" \
      "${RPI_BACKUP_JOBS_REMOTE_TARGETS[RPI_BACKUP_JOBS_INDEX]}" \
      "${RPI_BACKUP_JOBS_REMOTE_PARAMETERS[RPI_BACKUP_JOBS_INDEX]}"

  done
}

# shellcheck disable=SC2034
__backup_manifest_command_all_wrapper() {
  local RPI_BACKUP_MANIFEST_ALL_COMMAND="${1}"
  local RPI_BACKUP_JOB_NAME="${2}"
  local RPI_BACKUP_JOB_GROUP="${3}"
  local RPI_BACKUP_JOB_LOCAL_SOURCE="${4}"
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER="${5}"
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER="${6}"
  local RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS="${7}"
  local RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH="${8}"
  local RPI_BACKUP_JOB_REMOTE_TARGET="${9}"
  local RPI_BACKUP_JOB_REMOTE_PARAMETER="${10}"

  "${RPI_BACKUP_MANIFEST_ALL_COMMAND}"
}
