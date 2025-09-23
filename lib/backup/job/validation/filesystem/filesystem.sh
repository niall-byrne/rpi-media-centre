#!/bin/bash

# pictl backup job validation filesystem library

set -eo pipefail

_backup_job_validation_filesystem() {
  _backup_job_validation_filesystem_keyfile
  _backup_job_validation_filesystem_rsync
  _backup_job_validation_filesystem_source
  _backup_job_validation_filesystem_tarball
}

_backup_job_validation_filesystem_destination_path() {
  # $1: the path to check
  # $2: the octal permission to check for

  stdlib.io.path.assert.is_folder "${1}"
  stdlib.string.assert.is_octal_permission "${2}"
  stdlib.security.path.assert.is_secure "${1}" \
    "${RPI_SVC_USERNAME}" \
    "${RPI_SVC_GROUPNAME}" \
    "${2}"
}

_backup_job_validation_filesystem_source_path() {
  # $1: the path to check

  stdlib.io.path.assert.is_exists "${1}"
}
