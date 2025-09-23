#!/bin/bash

# pictl backup job validation argument remote target library

set -eo pipefail

_backup_job_validation_argument_remote_target() {
  case "${RPI_BACKUP_JOB_REMOTE_TARGET}" in
    "") ;; # KCOV_EXCLUDE_LINE
    "s3://"*)
      _backup_job_validation_argument_remote_parameter_s3
      ;;
    *)
      _backup_job_validation_error "Invalid remote storage target for this job." \
        _backup_job_message_remote_target
      ;;
  esac
}

_backup_job_validation_argument_remote_parameter_s3() {
  case "${RPI_BACKUP_JOB_REMOTE_PARAMETER}" in
    "")
      return 0
      ;;
    STANDARD | REDUCED_REDUNDANCY | STANDARD_IA | ONEZONE_IA | INTELLIGENT_TIERING | GLACIER | DEEP_ARCHIVE | GLACIER_IR)
      return 0
      ;;
    *)
      _backup_job_validation_error "Invalid remote S3 storage parameter for this job." \
        _backup_job_message_remote_param_s3
      ;;
  esac
}
