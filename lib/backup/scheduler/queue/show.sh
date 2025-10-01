#!/bin/bash

# pictl backup scheduler queue show library

set -eo pipefail

_backup_scheduler_queue_show() {
  _backup_scheduler_queue_make

  _dependencies_group_backups_cli_queue
  tree "${RPI_BACKUP_PATH_QUEUE_ROOT}"
}
