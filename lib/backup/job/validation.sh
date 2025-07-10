#!/bin/bash

# pictl backup job validation library

set -eo pipefail

_backup_job_validation() {
  # $1: the help function to call in the event that the job is invalid
  # $2: enable logging by setting this to any value

  local RPI_BACK_JOB_VALIDATION_LOGGING="${2}"

  # Enforce Mandatory Fields: RPI_BACKUP_JOB_NAME, RPI_BACKUP_JOB_GROUP, RPI_BACKUP_JOB_LOCAL_SOURCE
  # Also Require One Of: RPI_BACKUP_JOB_REMOTE_TARGET, RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER
  # Also Require Mutually: RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS, RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER
  # Also Allow Params Conditionally: RPI_BACKUP_JOB_REMOTE_PARAMETER

  if [[ -z ${RPI_BACKUP_JOB_NAME} ]] ||
    [[ -z "${RPI_BACKUP_JOB_LOCAL_SOURCE}" ]] ||
    [[ -z "${RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER}" && -z "${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}" && -z "${RPI_BACKUP_JOB_REMOTE_TARGET}" ]] ||
    [[ -n "${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}" && -z "${RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS}" ]] ||
    [[ -z "${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}" && -n "${RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS}" ]] ||
    [[ -z "${RPI_BACKUP_JOB_REMOTE_TARGET}" && -n "${RPI_BACKUP_JOB_REMOTE_PARAMETER}" ]]; then
    {
      echo " -- BACKUP JOB: Backup Job is INVALID!"
      "${1}"
    } >&2
  fi

  if [[ -n "${RPI_BACK_JOB_VALIDATION_LOGGING}" ]]; then
    echo " -- BACKUP JOB: Backup Job is VALID!"
    _backup_job_log
  fi

  if [[ -n "${RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER}" ]]; then
    _backup_job_validation_path "${RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER}"
    _dependencies_group_backups_rsync
  fi

  if [[ -n "${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}" ]]; then
    _backup_job_validation_path "${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}"
    _backup_job_validation_tarball_versions "${RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS}"
    _dependencies_group_backups_tarball
  fi

  _backup_job_validation_source "${RPI_BACKUP_JOB_LOCAL_SOURCE}"

  if [[ -n "${RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH}" ]]; then
    _backup_job_validation_key_file "${RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH}"
  fi

  _backup_job_validation_remote_target "${RPI_BACKUP_JOB_REMOTE_TARGET}" "${RPI_BACKUP_JOB_REMOTE_PARAMETER}"
}

_backup_job_validation_key_file() {
  # $1: the path to check

  _filesystem_check_exists "${1}"
  _security_path_check "${1}" "root" "root" "400"
}

_backup_job_validation_path() {
  # $1: the path to check

  _filesystem_check_is_folder "${1}"
  _security_path_check "${1}" "${RPI_SVC_USERNAME}" "${RPI_SVC_GROUPNAME}" "700"
}

_backup_job_validation_queue() {
  # $1: the queue name to check

  local RPI_BACKUP_QUEUE_NAME

  if [[ "${1}" == "${RPI_BACKUP_QUEUE_FAILED_TASK_EVENT}" ]]; then
    return 0
  fi

  # shellcheck disable=SC2153
  for RPI_BACKUP_QUEUE_NAME in "${RPI_BACKUP_QUEUE_NAMES[@]}"; do
    if [[ "${1}" == "${RPI_BACKUP_QUEUE_NAME}" ]]; then
      return 0
    fi
  done

  {
    echo " -- BACKUP JOB: Invalid queue for this job."
    _backup_job_log
    _backup_job_help_queue
  } >&2
  return 127
}

_backup_job_validation_remote_parameters_s3() {
  # $1: the S3 remote parameter to check

  case "${1}" in
    "")
      return 0
      ;;
    STANDARD | REDUCED_REDUNDANCY | STANDARD_IA | ONEZONE_IA | INTELLIGENT_TIERING | GLACIER | DEEP_ARCHIVE | GLACIER_IR)
      return 0
      ;;
    *)
      {
        echo " -- BACKUP JOB: Invalid remote S3 storage parameter for this job."
        _backup_job_log
        _backup_job_help_remote_parameters
      } >&2
      return 127
      ;;
  esac
}

_backup_job_validation_remote_target() {
  # $1: the remote target value to check
  # $2: the remote parameter value to check

  case "${1}" in
    "") ;;
    "s3://"*)
      _backup_job_validation_remote_parameters_s3 "${2}"
      _dependencies_group_backups_aws
      ;;
    *)
      {
        echo " -- BACKUP JOB: Invalid remote storage target for this job."
        _backup_job_log
        _backup_job_help_remote_target
      } >&2
      return 127
      ;;
  esac
}

_backup_job_validation_source() {
  # $1: the path to check

  _filesystem_check_exists "${1}"
}

_backup_job_validation_tarball_versions() {
  # $1: the local tarball version count to check

  if [[ "${1}" =~ ^[1-9]$ ]]; then
    return 0
  fi

  {
    echo " -- BACKUP JOB: Invalid local tarball version count."
    _backup_job_log
    _backup_job_help_tarball_versions
  } >&2
  return 127
}
