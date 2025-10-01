#!/bin/bash

# pictl backup scheduler queue enqueue library

set -eo pipefail

_backup_scheduler_queue_enqueue() {
  # $1: the type of entity to enqueue (group or name)
  # $2: the specific entity being enqueued

  local enqueue_entity_command

  case "${1}" in
    group | name)
      enqueue_entity_command="_backup_scheduler_queue_enqueue_${1}"
      ;;
    *)
      _cli_log_error "BACKUP SCHEDULER: Unknown entity type '${1}' !"
      return 127
      ;;
  esac

  _is_disk_mounted_all
  _backup_scheduler_queue_make

  _control_lock "rpi-backup-scheduler.pid" "15"

  "${enqueue_entity_command}" "${2}"

  _cli_log_success "BACKUP SCHEDULER: Scheduling complete !"
}

_backup_scheduler_queue_enqueue_group() {
  # $1: the group of backup jobs to schedule

  _cli_log_warning "BACKUP SCHEDULER: Scheduling the '${1}' group of backup jobs ..."
  _backup_manifest_all_command "_backup_manifest_write_jobs_all" "${1}"
}

_backup_scheduler_queue_enqueue_name() {
  # $1: the name of the backup job to schedule

  _cli_log_warning "BACKUP SCHEDULER: Scheduling the '${1}' backup job ..."
  _backup_manifest_all_command "_backup_manifest_write_jobs_all" "" "${1}"

}
