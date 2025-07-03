#!/bin/bash

# pictl backup job library

set -eo pipefail

_backup_job() {
  local RPI_BACKUP_JOB_NAME
  local RPI_BACKUP_JOB_LOCAL_SOURCE
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER
  local RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS
  local RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH
  local RPI_BACKUP_JOB_REMOTE_PARAMETER
  local RPI_BACKUP_JOB_REMOTE_TARGET
  local RPI_BACKUP_JOB_QUEUE

  _backup_job_args "$@"

  echo " -- BACKUP JOB: Executing '${RPI_BACKUP_JOB_QUEUE}' task for job '${RPI_BACKUP_JOB_NAME}' ..."

  case "${RPI_BACKUP_JOB_QUEUE}" in
    "${RPI_BACKUP_QUEUE_FAILED_TASK_EVENT}")
      RPI_BACKUP_JOB_QUEUE="${RPI_BACKUP_JOB_FAILURE_QUEUE}"
      _backup_job_task_event_wrapper "event-backup-job-task-error.sh"
      ;;
    rsync)
      _backup_job_task_rsync
      ;;
    tarball)
      _backup_job_task_tarball
      ;;
    upload)
      _backup_job_task_upload
      ;;
    *) ;;
  esac

  echo " -- BACKUP JOB: Completed '${RPI_BACKUP_JOB_QUEUE}' task for job '${RPI_BACKUP_JOB_NAME}' !"
}

_backup_job_args() {
  local OPTARG
  local OPTIND
  local OPTION

  echo " -- BACKUP JOB: Received: $(printf "%q " "$@")"

  while getopts "b:k:n:p:q:r:s:t:v:" OPTION; do
    case "$OPTION" in
      b)
        RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER="${OPTARG}"
        ;;
      k)
        RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH="${OPTARG}"
        ;;
      n)
        RPI_BACKUP_JOB_NAME="${OPTARG}"
        ;;
      p)
        RPI_BACKUP_JOB_REMOTE_PARAMETER="${OPTARG}"
        ;;
      q)
        RPI_BACKUP_JOB_QUEUE="${OPTARG}"
        ;;
      r)
        RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER="${OPTARG}"
        ;;
      s)
        RPI_BACKUP_JOB_LOCAL_SOURCE="${OPTARG}"
        ;;
      t)
        RPI_BACKUP_JOB_REMOTE_TARGET="${OPTARG}"
        ;;
      v)
        RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS="${OPTARG}"
        ;;
      *)
        _backup_job_usage >&2
        ;;
    esac
  done
  shift $((OPTIND - 1))

  _backup_job_validation "_backup_job_usage"
  _backup_job_validation_queue "${RPI_BACKUP_JOB_QUEUE}"

}

_backup_job_get_next_queue() {
  # $1: the current queue

  local RPI_BACKUP_PATH_SELECTED_QUEUE
  local RPI_BACKUP_JOB_QUEUE_MATCHING="0"

  # shellcheck disable=SC2153
  for RPI_BACKUP_PATH_SELECTED_QUEUE in "${RPI_BACKUP_QUEUE_NAMES[@]}"; do
    if [[ "${1}" == "${RPI_BACKUP_PATH_SELECTED_QUEUE}" ]]; then
      RPI_BACKUP_JOB_QUEUE_MATCHING="1"
      continue
    fi
    if [[ "${RPI_BACKUP_JOB_QUEUE_MATCHING}" == "1" ]]; then
      echo "${RPI_BACKUP_PATH_SELECTED_QUEUE}"
      return 0
    fi
  done

  echo ""
}

_backup_job_help_remote_parameters() {
  echo "Valid S3 Parameters:"
  echo "  - STANDARD (default value)"
  echo "  - REDUCED_REDUNDANCY"
  echo "  - STANDARD_IA"
  echo "  - ONEZONE_IA"
  echo "  - INTELLIGENT_TIERING"
  echo "  - GLACIER"
  echo "  - DEEP_ARCHIVE"
  echo "  - GLACIER_IR"
  echo "Please see https://aws.amazon.com/s3/storage-classes for details."
}

_backup_job_help_queue() {
  echo "Valid Queues:"
  echo -e "\t- rsync    \t- create rsync copy"
  echo -e "\t- tar      \t- create tar bundle"
  echo -e "\t- upload   \t- upload tar bundle to remote storage"
}

_backup_job_help_remote_target() {
  echo "Valid Targets:"
  echo "  - s3://bucket_name/path_name"
}

_backup_job_help_tarball_versions() {
  echo "Valid Version Count:"
  echo "  - any number between 1 and 9 (inclusive)"
}

_backup_job_help_usage() {
  echo "-- rpi-media-centre backup service job executor --"
  echo "Usage:"
  echo -e "\tpictl backup service job"
  echo -e "\t           \t-s [RPI_BACKUP_JOB_LOCAL_SOURCE]"
  echo -e "\t           \t-r [(optional) RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER]"
  echo -e "\t           \t-b [(optional) RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER]"
  echo -e "\t           \t-v [(optional) RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS]"
  echo -e "\t           \t-k [(optional) RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH]"
  echo -e "\t           \t-t [(optional) RPI_BACKUP_JOB_REMOTE_TARGET]"
  echo -e "\t           \t-p [(optional) RPI_BACKUP_JOB_REMOTE_PARAMETER]"
  echo -e "\t           \t-q [RPI_BACKUP_JOB_QUEUE]"
}

_backup_job_log() {
  echo "  RPI_BACKUP_JOB_NAME='${RPI_BACKUP_JOB_NAME}'"
  if [[ -n "${RPI_BACKUP_JOB_GROUP}" ]]; then
    echo "  RPI_BACKUP_JOB_GROUP='${RPI_BACKUP_JOB_GROUP}'"
  fi
  echo "  RPI_BACKUP_JOB_LOCAL_SOURCE='${RPI_BACKUP_JOB_LOCAL_SOURCE}'"
  echo "  RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER='${RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER}'"
  echo "  RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER='${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}'"
  echo "  RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS='${RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS}'"
  echo "  RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH='${RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH}'"
  echo "  RPI_BACKUP_JOB_REMOTE_TARGET='${RPI_BACKUP_JOB_REMOTE_TARGET}'"
  echo "  RPI_BACKUP_JOB_REMOTE_PARAMETER='${RPI_BACKUP_JOB_REMOTE_PARAMETER}'"
  if [[ -n "${RPI_BACKUP_JOB_QUEUE}" ]]; then
    echo "  RPI_BACKUP_JOB_GROUP='${RPI_BACKUP_JOB_QUEUE}'"
  fi
}

_backup_job_usage() {
  _backup_job_help_usage
  _backup_job_help_queue
  _backup_job_help_remote_target
  _backup_job_help_tarball_versions
  return 127
}
