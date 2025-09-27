#!/bin/bash

# pictl backup job task upload library

set -eo pipefail

_backup_job_task_upload() {
  case "${RPI_BACKUP_JOB_REMOTE_TARGET}" in
    "")
      _cli_log_notice " -- BACKUP JOB: No upload required for this job !"
      ;;
    "s3://"*)
      _backup_job_task_wrapper "_backup_job_task_upload_s3"
      ;;
  esac
}

_backup_job_task_upload_s3() {
  local RPI_BACKUP_JOB_UPLOAD_OPTIONS=()
  local RPI_BACKUP_JOB_UPLOAD_EXPECTED_SIZE
  local RPI_BACKUP_JOB_UPLOAD_STORAGE_CLASS="${RPI_BACKUP_JOB_REMOTE_PARAMETER:-STANDARD}"

  RPI_BACKUP_JOB_UPLOAD_OPTIONS+=("--storage-class=${RPI_BACKUP_JOB_UPLOAD_STORAGE_CLASS}")

  if [[ -n "${RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH}" ]]; then
    RPI_BACKUP_JOB_UPLOAD_OPTIONS+=("--sse-c" "AES256" "--sse-c-key" "fileb://${RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH}")
  fi

  if [[ -n "${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}" ]]; then
    _backup_job_task_upload_s3_from_latest_tarball
  else
    _control_pushd "$(dirname "${RPI_BACKUP_JOB_LOCAL_SOURCE}")" "_backup_job_task_upload_s3_from_tarball_stream"
  fi
}

_backup_job_task_upload_s3_from_latest_tarball() {
  _control_retries "5" "_backup_job_task_upload_s3_from_latest_tarball_retryable"
}

_backup_job_task_upload_s3_from_latest_tarball_retryable() {
  aws --cli-connect-timeout "${RPI_BACKUP_S3_REMOTE_TIMEOUT_CONNECT}" \
    --cli-read-timeout "${RPI_BACKUP_S3_REMOTE_TIMEOUT_READ}" \
    s3 cp \
    --no-progress \
    "$(_backup_job_task_tarball_get_latest_filename)" \
    "${RPI_BACKUP_JOB_REMOTE_TARGET}/${RPI_BACKUP_JOB_NAME}.tar" \
    "${RPI_BACKUP_JOB_UPLOAD_OPTIONS[@]}"
}

_backup_job_task_upload_s3_estimate_tarball_size() {
  _cli_log_notice " -- BACKUP JOB: Calculating size of '${RPI_BACKUP_JOB_LOCAL_SOURCE}' ..."
  RPI_BACKUP_JOB_UPLOAD_EXPECTED_SIZE="$(
    tar \
      --totals \
      -czf \
      /dev/null \
      "$(basename "${RPI_BACKUP_JOB_LOCAL_SOURCE}")" 2>&1 |
      sed 's/.*Total bytes written: \([0-9]*\) .*/\1/g'
  )"
  RPI_BACKUP_JOB_UPLOAD_OPTIONS+=("--expected-size=${RPI_BACKUP_JOB_UPLOAD_EXPECTED_SIZE}")
}

_backup_job_task_upload_s3_from_tarball_stream() {
  _backup_job_task_upload_s3_estimate_tarball_size
  _control_retries "5" _backup_job_task_upload_s3_from_tarball_stream_retryable
}

_backup_job_task_upload_s3_from_tarball_stream_retryable() {
  tar c \
    "$(basename "${RPI_BACKUP_JOB_LOCAL_SOURCE}")" |
    aws --cli-connect-timeout "${RPI_BACKUP_S3_REMOTE_TIMEOUT_CONNECT}" \
      --cli-read-timeout "${RPI_BACKUP_S3_REMOTE_TIMEOUT_READ}" \
      s3 cp \
      --no-progress \
      - \
      "${RPI_BACKUP_JOB_REMOTE_TARGET}/${RPI_BACKUP_JOB_NAME}.tar" \
      "${RPI_BACKUP_JOB_UPLOAD_OPTIONS[@]}"
}
