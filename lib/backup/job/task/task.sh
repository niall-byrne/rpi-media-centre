#!/bin/bash

# pictl backup job task library

set -eo pipefail

_backup_job_task_event_wrapper() {
  # $1: the event script to call

  (
    export RPI_BACKUP_JOB_NAME
    export RPI_BACKUP_JOB_LOCAL_SOURCE
    export RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER
    export RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER
    export RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS
    export RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH
    export RPI_BACKUP_JOB_REMOTE_TARGET
    export RPI_BACKUP_JOB_QUEUE

    _event_script "${1}"
  )
}

_backup_job_task_wrapper() {
  # $1: the command to execute
  # $@: arguments for the command

  export RPI_BACKUP_JOB_COMMAND=("${@}")

  _backup_job_task_event_wrapper "event-backup-job-task-before.sh"
  "${RPI_BACKUP_JOB_COMMAND[0]}" "${RPI_BACKUP_JOB_COMMAND[@]:1}"
  _backup_job_task_event_wrapper "event-backup-job-task-after.sh"

  export -n RPI_BACKUP_JOB_COMMAND
}
