#!/bin/bash

# pictl backup scheduler error library

set -eo pipefail

_backup_scheduler_error() {
  # $1: the failed job's queue
  # $2: the failed job's file path

  _cli_log_error "BACKUP SCHEDULER: Backup job '${RPI_BACKUP_JOB_NAME}' - has failed the '${1}' task !"

  # execute the failed job task again with job status 1 in order to fire a task error event
  if ! RPI_BACKUP_JOB_STATUS="${RPI_BACKUP_JOB_STATUSES[1]}" "${2}" "${1}" > /dev/null 2>&1; then
    _cli_log_error "BACKUP SCHEDULER: Backup job '${RPI_BACKUP_JOB_NAME}' - appears improperly configured !"
    _event_script "event-backup-scheduler-error.sh"
  else
    _cli_log_error "BACKUP SCHEDULER: This job will be retried tomorrow."
  fi
}
