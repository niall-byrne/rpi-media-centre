#!/bin/bash

# pictl backup scheduler queue dequeue library

set -eo pipefail

_backup_scheduler_queue_dequeue_all_from() {
  # $1: the queue folder to load jobs from

  local backup_job_file

  for backup_job_file in "${RPI_BACKUP_PATH_QUEUE_ROOT}/${1}/"*; do
    if stdlib.io.path.query.is_exists "${backup_job_file}"; then
      _backup_scheduler_execute "${1}" "${backup_job_file}"
      _cli_log_notice "BACKUP SCHEDULER: =========================================="
    fi
  done
}
