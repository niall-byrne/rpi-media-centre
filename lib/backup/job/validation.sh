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

  if [[ -z ${RPI_BACKUP_JOB_NAME} ]] ||
    [[ -z "${RPI_BACKUP_JOB_LOCAL_SOURCE}" ]] ||
    [[ -z "${RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER}" && -z "${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}" && -z "${RPI_BACKUP_JOB_REMOTE_TARGET}" ]] ||
    [[ -n "${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}" && -z "${RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS}" ]] ||
    [[ -z "${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}" && -n "${RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS}" ]]; then
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
  fi

  if [[ -n "${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}" ]]; then
    _backup_job_validation_path "${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}"
    _backup_job_validation_tarball_versions "${RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS}"
  fi

  _backup_job_validation_source "${RPI_BACKUP_JOB_LOCAL_SOURCE}"

  if [[ -n "${RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH}" ]]; then
    _backup_job_validation_key_file "${RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH}"
  fi

  _backup_job_validation_remote_target "${RPI_BACKUP_JOB_REMOTE_TARGET}"
}

_backup_job_validation_key_file() {
  # $1: the path to check

  _filesystem_check_exists "${1}"
  _filesystem_check_permissions "${1}" "400"
}

_backup_job_validation_path() {
  # $1: the path to check

  _filesystem_check_is_folder "${1}"
  _filesystem_check_permissions "${1}" "700"
}

_backup_job_validation_queue() {
  # $1: the queue name to check

  local RPI_BACKUP_QUEUE_NAME

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

_backup_job_validation_remote_target() {
  # $1: the remote target value to check

  case "${1}" in
    "") ;;
    "s3://"*)
      if command -v aws > /dev/null; then
        return 0
      fi
      {
        echo " -- BACKUP JOB: The aws cli is required for this job, but it is not installed."
        _backup_job_log
        echo " -- BACKUP JOB: Please see https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
      } >&2
      return 127
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
