#!/bin/bash

# pictl backup scheduler queue forward library

set -eo pipefail

_backup_scheduler_queue_forward_from() {
  # $1: the current queue

  local selected_queue
  local queue_found_boolean="0"

  # shellcheck disable=SC2153
  for selected_queue in "${RPI_BACKUP_QUEUE_NAMES[@]}"; do
    if [[ "${1}" == "${selected_queue}" ]]; then
      queue_found_boolean="1"
      continue
    fi
    if [[ "${queue_found_boolean}" == "1" ]]; then
      echo "${selected_queue}"
      return 0
    fi
  done

  echo ""
}
