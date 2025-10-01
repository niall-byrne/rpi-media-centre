#!/bin/bash

# pictl backup scheduler library

set -eo pipefail

RPI_BACKUP_QUEUE_NAMES=("rsync" "tarball" "upload")
RPI_BACKUP_JOB_STATUSES=("OK" "FAILED")

_backup_scheduler_execute() {
  # $1: the loaded job's queue
  # $2: the loaded job's file path

  local RPI_BACKUP_JOB_NAME

  RPI_BACKUP_JOB_NAME="$(basename "${2}")"

  _cli_log_notice "BACKUP SCHEDULER: Backup job '${RPI_BACKUP_JOB_NAME}' - is starting the '${1}' task ..."

  if ! RPI_BACKUP_JOB_STATUS="${RPI_BACKUP_JOB_STATUSES[0]}" "${2}" "${1}"; then
    _backup_scheduler_error "${1}" "${2}"
    return 0
  fi

  _cli_log_success "BACKUP SCHEDULER: Backup job '${RPI_BACKUP_JOB_NAME}' - is completed the '${1}' task !"

  _backup_scheduler_forward "${1}" "${2}" "${RPI_BACKUP_JOB_NAME}"
}

_backup_scheduler_forward() {
  # $1: the loaded job's queue
  # $2: the loaded job file path
  # $3: the loaded job's name

  local rpi_backup_job_next_queue
  local rpi_backup_job_next_path

  rpi_backup_job_next_queue="$(_backup_scheduler_queue_forward_from "${1}")"

  if [[ -n "${rpi_backup_job_next_queue}" ]]; then
    _cli_log_warning "BACKUP SCHEDULER: New task '${rpi_backup_job_next_queue}' for backup job '${3}' ..."
    rpi_backup_job_next_path="${RPI_BACKUP_PATH_QUEUE_ROOT}/${rpi_backup_job_next_queue}/${3}"
    mv "${2}" "${rpi_backup_job_next_path}"
    _backup_scheduler_execute "${rpi_backup_job_next_queue}" "${rpi_backup_job_next_path}"
  else
    rm "${2}"
  fi
}

_backup_scheduler_start() {
  local queue_index

  if _backup_scheduler_query_is_available; then
    _event_script "event-backup-scheduler-before.sh"
    _cli_log_notice "BACKUP SCHEDULER: Executing all processable backup jobs ..."

    # Iterate over jobs in reverse queue order, so that failed jobs are finished before new ones.
    for ((queue_index = ${#RPI_BACKUP_QUEUE_NAMES[@]} - 1; queue_index >= 0; queue_index--)); do
      _backup_scheduler_queue_dequeue_all_from "${RPI_BACKUP_QUEUE_NAMES[queue_index]}"
    done

    _cli_log_notice "BACKUP SCHEDULER: Execution has stopped cleanly."
    _event_script "event-backup-scheduler-after.sh"
  else
    _cli_log_error "BACKUP SCHEDULER: The scheduler is available between ${RPI_BACKUP_SCHEDULER_START_TIME} and ${RPI_BACKUP_SCHEDULER_END_TIME} daily."
  fi
}
