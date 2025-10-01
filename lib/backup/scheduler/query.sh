#!/bin/bash

# pictl backup scheduler query library

set -eo pipefail

_backup_scheduler_query_is_available() {
  local rpi_scheduler_start_epoch
  local rpi_scheduler_end_epoch
  local rpi_scheduler_current_epoch

  rpi_scheduler_start_epoch="$(date -ud "${RPI_BACKUP_SCHEDULER_START_TIME} today" +%s)"
  rpi_scheduler_end_epoch="$(date -ud "${RPI_BACKUP_SCHEDULER_END_TIME} today" +%s)"
  rpi_scheduler_current_epoch="$(date -u +%s)"

  if (("${rpi_scheduler_current_epoch}" >= "${rpi_scheduler_start_epoch}")) &&
    (("${rpi_scheduler_current_epoch}" <= "${rpi_scheduler_end_epoch}")); then
    return 0
  fi
  return 1
}
