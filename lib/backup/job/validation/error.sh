#!/bin/bash

# pictl backup job validation error library

set -eo pipefail

_backup_job_validation_error() {
  # $1: error message
  # $2: error content generator

  _cli_log_error " -- BACKUP JOB: ${1}"
  {
    _backup_job_log
    "${2}"
  } >&2 # KCOV_EXCLUDE_LINE

  return 127
}
