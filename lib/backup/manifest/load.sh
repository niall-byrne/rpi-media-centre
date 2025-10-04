#!/bin/bash

# pictl backup manifest load library

set -eo pipefail

_backup_manifest_load() {
  local FILE_LINE
  local RPI_BACKUP_JOB_INDEX
  local RPI_BACKUP_JOB_NAME
  local RPI_BACKUP_JOB_GROUP
  local RPI_BACKUP_JOB_LOCAL_SOURCE
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER
  local RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS
  local RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH
  local RPI_BACKUP_JOB_REMOTE_TARGET
  local RPI_BACKUP_JOB_REMOTE_PARAMETER

  _cli_log_notice "-- loading ${RPI_MANIFEST_BACKUP} file ... --"

  if ! stdlib.io.path.query.is_exists "${RPI_MANIFEST_BACKUP}"; then
    _cli_log_error "Please create the ${RPI_MANIFEST_BACKUP} file to use this feature."
    {
      _backup_manifest_help
    } >&2 # KCOV_EXCLUDE_LINE
    return 127
  fi

  stdlib.security.path.query.is_secure "${RPI_MANIFEST_BACKUP}" "root" "root" "600"

  while IFS= read -r FILE_LINE; do

    # Ignore comments
    if [[ "${FILE_LINE:0:1}" == "#" ]]; then
      continue
    fi

    # Ignore blank lines
    if [[ "${FILE_LINE}" == "" ]]; then
      continue
    fi

    IFS="," read -r \
      RPI_BACKUP_JOB_NAME \
      RPI_BACKUP_JOB_GROUP \
      RPI_BACKUP_JOB_LOCAL_SOURCE \
      RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER \
      RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER \
      RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS \
      RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH \
      RPI_BACKUP_JOB_REMOTE_TARGET \
      RPI_BACKUP_JOB_REMOTE_PARAMETER \
      <<< "$FILE_LINE"

    for ((RPI_BACKUP_JOB_INDEX = 0; RPI_BACKUP_JOB_INDEX < "${#RPI_BACKUP_JOBS_NAMES[@]}"; RPI_BACKUP_JOB_INDEX++)); do
      if [[ "${RPI_BACKUP_JOBS_NAMES["${RPI_BACKUP_JOB_INDEX}"]}" == "${RPI_BACKUP_JOB_NAME}" ]]; then

        _cli_log_error "The backup job name '${RPI_BACKUP_JOB_NAME}' is used multiple times, this value must be unique."
        _backup_manifest_line_log_invalid
      fi
    done

    _backup_manifest_line_validate

    RPI_BACKUP_JOBS_NAMES+=("${RPI_BACKUP_JOB_NAME}")
    RPI_BACKUP_JOBS_GROUPS+=("${RPI_BACKUP_JOB_GROUP}")
    RPI_BACKUP_JOBS_LOCAL_SOURCES+=("${RPI_BACKUP_JOB_LOCAL_SOURCE}")
    RPI_BACKUP_JOBS_LOCAL_RSYNC_FOLDERS+=("${RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER}")
    RPI_BACKUP_JOBS_LOCAL_TARBALL_FOLDERS+=("${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}")
    RPI_BACKUP_JOBS_LOCAL_TARBALL_VERSIONS+=("${RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS}")
    RPI_BACKUP_JOBS_REMOTE_ENCRYPTION_KEY_PATHS+=("${RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH}")
    RPI_BACKUP_JOBS_REMOTE_TARGETS+=("${RPI_BACKUP_JOB_REMOTE_TARGET}")
    RPI_BACKUP_JOBS_REMOTE_PARAMETERS+=("${RPI_BACKUP_JOB_REMOTE_PARAMETER}")

  done < "${RPI_MANIFEST_BACKUP}" # KCOV_EXCLUDE_LINE
}
