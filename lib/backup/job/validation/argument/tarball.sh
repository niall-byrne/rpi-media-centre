#!/bin/bash

# pictl backup job validation argument tarball library

set -eo pipefail

_backup_job_validation_argument_tarball_versions() {
  # $1: the local tarball version count to check

  if [[ -n "${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}" ]]; then
    if stdlib.string.query.is_integer_with_range 1 9 "${RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS}"; then
      return 0
    fi

    _backup_job_validation_error "Invalid local tarball version count." \
      _backup_job_message_tarball_versions
  fi
}
