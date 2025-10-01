#!/bin/bash

# pictl backup scheduler validation library

set -eo pipefail

_backup_scheduler_validation() {
  rpi_scheduler_start_epoch=$(date -ud "${RPI_BACKUP_SCHEDULER_START_TIME} today" +%s)
  rpi_scheduler_end_epoch=$(date -ud "${RPI_BACKUP_SCHEDULER_END_TIME} today" +%s)

  if (("${rpi_scheduler_start_epoch}" >= "${rpi_scheduler_end_epoch}")); then
    _cli_log_error "BACKUP SCHEDULER: Scheduling error !"
    _cli_log_error "The value for RPI_BACKUP_SCHEDULER_START_TIME must come before the value for RPI_BACKUP_SCHEDULER_END_TIME !"
    _cli_log_info "Please revise your /etc/rpi/config file."
    return 127
  fi
}
