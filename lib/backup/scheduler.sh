#!/bin/bash

# pictl backup scheduler library

set -eo pipefail

RPI_BACKUP_QUEUE_NAMES=("rsync" "tarball" "upload")
RPI_BACKUP_QUEUE_FAILED_TASK_EVENT="failed_job_task_event"

_backup_scheduler_dequeue() {
  # $1: the queue folder to load jobs from

  local RPI_BACKUP_JOB

  for RPI_BACKUP_JOB in "${RPI_BACKUP_PATH_QUEUE_ROOT}/${1}/"*; do
    if [[ ! -e "${RPI_BACKUP_JOB}" ]]; then
      continue
    fi
    _backup_scheduler_job_run "${1}" "${RPI_BACKUP_JOB}"
    echo "BACKUP SCHEDULER: =========================================="
  done
}

_backup_scheduler_is_available() {
  local RPI_SCHEDULER_START_EPOCH
  local RPI_SCHEDULER_END_EPOCH
  local RPI_SCHEDULER_CURRENT_EPOCH

  RPI_SCHEDULER_START_EPOCH="$(date -ud "${RPI_BACKUP_SCHEDULER_START_TIME} today" +%s)"
  RPI_SCHEDULER_END_EPOCH="$(date -ud "${RPI_BACKUP_SCHEDULER_END_TIME} today" +%s)"
  RPI_SCHEDULER_CURRENT_EPOCH="$(date -u +%s)"

  if (("${RPI_SCHEDULER_CURRENT_EPOCH}" >= "${RPI_SCHEDULER_START_EPOCH}")) &&
    (("${RPI_SCHEDULER_CURRENT_EPOCH}" <= "${RPI_SCHEDULER_END_EPOCH}")); then
    return 0
  fi
  return 1
}

_backup_scheduler_job_promote() {
  # $1: the loaded job's queue
  # $2: the loaded job file path
  # $3: the loaded job's name

  local RPI_BACKUP_JOB_NEXT_QUEUE
  local RPI_BACKUP_JOB_NEXT_PATH

  RPI_BACKUP_JOB_NEXT_QUEUE="$(_backup_job_get_next_queue "${1}")"

  if [[ -n "${RPI_BACKUP_JOB_NEXT_QUEUE}" ]]; then
    echo "BACKUP SCHEDULER: Promoted! New task '${RPI_BACKUP_JOB_NEXT_QUEUE}' for backup job '${3}' ..."
    RPI_BACKUP_JOB_NEXT_PATH="${RPI_BACKUP_PATH_QUEUE_ROOT}/${RPI_BACKUP_JOB_NEXT_QUEUE}/${3}"
    mv "${2}" "${RPI_BACKUP_JOB_NEXT_PATH}"
    _backup_scheduler_job_run "${RPI_BACKUP_JOB_NEXT_QUEUE}" "${RPI_BACKUP_JOB_NEXT_PATH}"
  else
    rm "${2}"
  fi
}

_backup_scheduler_job_run() {
  # $1: the loaded job's queue
  # $2: the loaded job's file path

  local RPI_BACKUP_JOB_NAME

  RPI_BACKUP_JOB_NAME="$(basename "${2}")"

  echo "BACKUP SCHEDULER: Backup job '${RPI_BACKUP_JOB_NAME}' - is starting the '${1}' task ..."

  if ! "${2}" "${1}"; then
    echo "BACKUP SCHEDULER: Backup job '${RPI_BACKUP_JOB_NAME}' - has failed the '${1}' task !"
    echo "BACKUP SCHEDULER: This job will be retried tomorrow."

    (
      export RPI_BACKUP_JOB_NAME
      export RPI_BACKUP_JOB_FAILURE_QUEUE="${2}"

      # execute the failed job task again to fire a task error event with the job arguments
      if ! "${2}" "${RPI_BACKUP_QUEUE_FAILED_TASK_EVENT}"; then
        # if the job itself cannot be parsed then fire a scheduler error event
        _event_script "event-backup-scheduler-error.sh"
      fi
    )

    return 0
  fi

  echo "BACKUP SCHEDULER: Backup job '${RPI_BACKUP_JOB_NAME}' - is completed the '${1}' task !"

  _backup_scheduler_job_promote "${1}" "${2}" "${RPI_BACKUP_JOB_NAME}"
}

_backup_scheduler_make_queues() {
  local RPI_BACKUP_PATH_SELECTED_QUEUE

  for RPI_BACKUP_PATH_SELECTED_QUEUE in "${RPI_BACKUP_QUEUE_NAMES[@]}"; do
    mkdir -p "${RPI_BACKUP_PATH_QUEUE_ROOT}/${RPI_BACKUP_PATH_SELECTED_QUEUE}"
    chmod 700 -R "${RPI_BACKUP_PATH_QUEUE_ROOT}/${RPI_BACKUP_PATH_SELECTED_QUEUE}"
  done

  chmod 700 -R "${RPI_BACKUP_PATH_QUEUE_ROOT}"
}

_backup_scheduler_validate_schedule() {
  RPI_SCHEDULER_START_EPOCH=$(date -ud "${RPI_BACKUP_SCHEDULER_START_TIME} today" +%s)
  RPI_SCHEDULER_END_EPOCH=$(date -ud "${RPI_BACKUP_SCHEDULER_END_TIME} today" +%s)

  if (("${RPI_SCHEDULER_START_EPOCH}" >= "${RPI_SCHEDULER_END_EPOCH}")); then
    {
      echo "Backup Job Scheduler Error!"
      echo "The value for RPI_BACKUP_SCHEDULER_START_TIME must come before the value for RPI_BACKUP_SCHEDULER_END_TIME !"
      echo "Please revise your .rpi/config file."
    } >&2
    return 127
  fi
}
