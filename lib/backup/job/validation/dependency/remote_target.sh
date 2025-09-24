#!/bin/bash

# pictl backup job validation dependency remote target library

set -eo pipefail

_backup_job_validation_dependency_remote_target() {
  case "${RPI_BACKUP_JOB_REMOTE_TARGET}" in
    "") ;; # KCOV_EXCLUDE_LINE
    "s3://"*)
      _dependencies_group_backups_aws
      ;;
  esac
}