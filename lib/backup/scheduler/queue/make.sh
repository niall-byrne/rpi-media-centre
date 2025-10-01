#!/bin/bash

# pictl backup scheduler queue make library

set -eo pipefail

_backup_scheduler_queue_make() {
  local queue_name

  for queue_name in "${RPI_BACKUP_QUEUE_NAMES[@]}"; do
    stdlib.security.path.make.dir "${RPI_BACKUP_PATH_QUEUE_ROOT}/${queue_name}" \
      "${RPI_SVC_USERNAME}" \
      "${RPI_SVC_GROUPNAME}" \
      "700"
  done

  stdlib.security.path.secure "${RPI_BACKUP_PATH_QUEUE_ROOT}" \
    "${RPI_SVC_USERNAME}" \
    "${RPI_SVC_GROUPNAME}" \
    "700"
}
