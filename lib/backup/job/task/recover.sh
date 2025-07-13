#!/bin/bash

# pictl backup job task recover library

set -eo pipefail

_backup_job_task_recover() {
  case "${RPI_BACKUP_JOB_REMOTE_TARGET}" in
    "")
      echo " -- BACKUP JOB: The specified job was not stored remotely !"
      ;;
    "s3://"*)
      _backup_job_task_wrapper "_backup_job_task_recover_s3"
      ;;
    *) ;;
  esac
}

_backup_job_task_recover_s3() {
  local RPI_BACKUP_JOB_UPLOAD_OPTIONS=()
  local RPI_BACKUP_JOB_RECOVERED_FILENAME

  if [[ -n "${RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH}" ]]; then
    RPI_BACKUP_JOB_UPLOAD_OPTIONS+=("--sse-c" "AES256" "--sse-c-key" "fileb://${RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH}")
  fi

  echo "Starting data recovery for job '${RPI_BACKUP_JOB_NAME}' ..."

  RPI_BACKUP_JOB_RECOVERED_FILENAME="${RPI_BACKUP_JOB_RECOVERY_PATH}/${RPI_BACKUP_JOB_NAME}-recovered.tar"

  aws s3 cp \
    "${RPI_BACKUP_JOB_REMOTE_TARGET}/${RPI_BACKUP_JOB_NAME}.tar" \
    "${RPI_BACKUP_JOB_RECOVERED_FILENAME}" \
    "${RPI_BACKUP_JOB_UPLOAD_OPTIONS[@]}"

  _security_path_secure \
    "${RPI_BACKUP_JOB_RECOVERED_FILENAME}" \
    "${RPI_SVC_USERNAME}" \
    "${RPI_SVC_GROUPNAME}" \
    "600"

  echo "Data recovery for job '${RPI_BACKUP_JOB_NAME}' was successful !"
}
