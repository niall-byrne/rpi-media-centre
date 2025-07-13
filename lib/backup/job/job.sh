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

  _cli_log_notice " -- BACKUP JOB: Executing '${RPI_BACKUP_JOB_QUEUE}' task for job '${RPI_BACKUP_JOB_NAME}' ..."

  if [[ "${RPI_BACKUP_JOB_QUEUE}" == "${RPI_BACKUP_QUEUE_FAILED_TASK_EVENT}" ]]; then
    RPI_BACKUP_JOB_QUEUE="${RPI_BACKUP_JOB_FAILURE_QUEUE}"
    _backup_job_task_event_wrapper "event-backup-job-task-error.sh"
    return 0
  fi

  _backup_job_cli "${RPI_BACKUP_JOB_QUEUE}"

  _cli_log_notice " -- BACKUP JOB: Completed '${RPI_BACKUP_JOB_QUEUE}' task for job '${RPI_BACKUP_JOB_NAME}' !"
}

_backup_job_args() {
  local OPTARG
  local OPTIND
  local OPTION

  _cli_log_info " -- BACKUP JOB: Received: $(printf "%q " "$@")"

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
        _backup_job_usage
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
  {
    _backup_job_cli_usage
    _backup_job_message_tarball_versions
    _backup_job_message_remote_target
    _backup_job_message_remote_param
    _backup_job_message_queue
  } >&2
  return 127
}
