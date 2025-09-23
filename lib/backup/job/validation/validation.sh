#!/bin/bash

# pictl backup job validation library

set -eo pipefail

RPI_BACKUP_JOB_ALL_VALIDATORS_ARRAY=("argument" "dependency" "filesystem")

_backup_job_validation() {
  # $1: the help function to call in the event that the job is invalid
  # $2: enable logging by setting this boolean
  # _RPI_BACKUP_JOB_DISABLED_VALIDATORS: an array of validators to skip running

  # shellcheck disable=SC2034
  local backup_job_disabled_validators=("${_RPI_BACKUP_JOB_DISABLED_VALIDATORS[@]}")
  local backup_job_help_details_fn="${1}"
  local backup_job_log_valid_jobs_boolean="${2}"
  local backup_job_validator
  local backup_job_validators=("${RPI_BACKUP_JOB_ALL_VALIDATORS_ARRAY[@]}")

  if ! _backup_job_validation_argument_combinations; then
    _cli_log_error " -- BACKUP JOB: Backup Job is INVALID!"
    {
      "${backup_job_help_details_fn}"
    } >&2 # KCOV_EXCLUDE_LINE
  fi

  if [[ "${backup_job_log_valid_jobs_boolean}" == "1" ]]; then
    _cli_log_success " -- BACKUP JOB: Backup Job is VALID!"
    _backup_job_log
  fi

  for backup_job_validator in "${backup_job_validators[@]}"; do
    if ! stdlib.array.query.is_contains "${backup_job_validator}" backup_job_disabled_validators; then
      "_backup_job_validation_${backup_job_validator}"
    fi
  done
}

_backup_job_validation_argument_combinations() {
  # Enforce Mandatory Fields: RPI_BACKUP_JOB_NAME, RPI_BACKUP_JOB_GROUP, RPI_BACKUP_JOB_LOCAL_SOURCE
  # Also Require One Of: RPI_BACKUP_JOB_REMOTE_TARGET, RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER
  # Also Require Mutually: RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS, RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER
  # Also Allow Params Conditionally: RPI_BACKUP_JOB_REMOTE_PARAMETER, RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH

  if [[ -z "${RPI_BACKUP_JOB_NAME}" ]] ||
    [[ -z "${RPI_BACKUP_JOB_GROUP}" ]] ||
    [[ -z "${RPI_BACKUP_JOB_LOCAL_SOURCE}" ]] ||
    [[ -z "${RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER}" && -z "${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}" && -z "${RPI_BACKUP_JOB_REMOTE_TARGET}" ]] ||
    [[ -n "${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}" && -z "${RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS}" ]] ||
    [[ -z "${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}" && -n "${RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS}" ]] ||
    [[ -z "${RPI_BACKUP_JOB_REMOTE_TARGET}" && -n "${RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH}" ]] ||
    [[ -z "${RPI_BACKUP_JOB_REMOTE_TARGET}" && -n "${RPI_BACKUP_JOB_REMOTE_PARAMETER}" ]]; then
    return 1
  fi

  return 0
}

_backup_job_validation_queue() {
  local selected_queue_name
  local valid_queue_names_array=("${RPI_BACKUP_QUEUE_NAMES[@]}" "${RPI_BACKUP_QUEUE_FAILED_TASK_EVENT}")

  # shellcheck disable=SC2153
  for selected_queue_name in "${valid_queue_names_array[@]}"; do
    if [[ "${RPI_BACKUP_JOB_QUEUE}" == "${selected_queue_name}" ]]; then
      return 0
    fi
  done

  _backup_job_validation_error "Invalid queue for this job." \
    _backup_job_message_queue
}
