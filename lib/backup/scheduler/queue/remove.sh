#!/bin/bash

# pictl backup scheduler queue remove library

set -eo pipefail

_backup_scheduler_queue_remove_name() {
  # $1: the name of the backup job to remove

  _backup_scheduler_queue_make

  find "${RPI_BACKUP_PATH_QUEUE_ROOT}" -type f -name "${1}" -delete
  _cli_log_success "BACKUP SCHEDULER: Queued backup jobs matching '${1}' have been removed !"
}

_backup_scheduler_queue_remove_all() {
  _backup_scheduler_queue_make

  find "${RPI_BACKUP_PATH_QUEUE_ROOT}" -type f -delete
  _cli_log_success "BACKUP SCHEDULER: All queued backup jobs have been removed !"
}
