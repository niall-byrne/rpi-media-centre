#!/bin/bash

# pictl backup cli library

set -eo pipefail

_backup_cli_keyfile-s3() {
  # $1: the filename for the new keyfile

  if [[ -z "${1}" ]]; then
    _backup_cli_usage_error
  fi

  _dependencies_group_backups_cli_keyfile

  _cli_log_warning "BACKUP SCHEDULER: Generating a new AWS S3 encryption key ..."

  stdlib.io.path.assert.not_exists "${1}"
  openssl rand -out "${1}" 32
  stdlib.security.path.secure "${1}" "root" "root" "600"

  _cli_log_success "BACKUP SCHEDULER: Successfully generated '${1}' !"
}

_backup_cli_queue_cli_remove() {
  # $1: the name of the backup job to remove

  if [[ -z "${1}" ]]; then
    _backup_cli_queue_cli_usage_error
  fi

  _cli_log_warning "BACKUP SCHEDULER: Remove queued backup jobs matching '${1}' ..."

  _backup_scheduler_make_queues

  if stdlib.io.stdin.confirmation; then
    find "${RPI_BACKUP_PATH_QUEUE_ROOT}" -type f -name "${1}" -delete
    _cli_log_success "BACKUP SCHEDULER: Queued backup jobs matching '${1}' have been removed !"
  fi
}

_backup_cli_queue_cli_remove-all() {
  _cli_log_warning "BACKUP SCHEDULER: Remove *all* queued backup jobs ..."

  _backup_scheduler_make_queues

  if stdlib.io.stdin.confirmation; then
    find "${RPI_BACKUP_PATH_QUEUE_ROOT}" -type f -delete
    _cli_log_success "BACKUP SCHEDULER: All queued backup jobs have been removed !"
  fi
}

_backup_cli_queue_cli_show() {
  _backup_scheduler_make_queues

  _dependencies_group_backups_cli_queue
  tree "${RPI_BACKUP_PATH_QUEUE_ROOT}"
}

_backup_cli_recover() {
  # $1: the name of the backup job
  # $2: the local bath to restore it to

  local RPI_BACKUP_JOB_RECOVERY_PATH

  if [[ -z "${1}" ]] ||
    [[ -z "${2}" ]]; then
    _backup_cli_usage_error
  fi

  # shellcheck disable=SC2034
  RPI_BACKUP_JOB_RECOVERY_PATH="$(_filesystem_resolve_path_relative_to_cli "${2}")"

  _backup_manifest_all_command "_backup_job_task_recover" "" "${1}"
}

_backup_cli_schedule() {
  # $1: the group of backup jobs to schedule

  # Disable filesystem access during scheduling to prevent waking hard disks
  local _RPI_BACKUP_JOB_DISABLED_VALIDATORS=("filesystem")

  if [[ -z "${1}" ]]; then
    _backup_cli_usage_error
  fi

  _is_disk_mounted_all

  _control_lock "rpi-backup-scheduler.pid" "15"

  _backup_scheduler_make_queues

  _cli_log_warning "BACKUP SCHEDULER: Scheduling the '${1}' group of backup jobs ..."
  _backup_manifest_all_command "_backup_manifest_write_jobs_all" "${1}"
  _cli_log_success "BACKUP SCHEDULER: Scheduling complete !"
}

_backup_cli_service_cli_--restricted--() {
  if [[ "${RPI_RUNTIME_ENVIRONMENT}" != "service" ]]; then
    _cli_log_error "This command is restricted to the systemd backup service !"
    return 127
  fi
}

_backup_cli_service_cli_before_all() {
  _is_disk_mounted_all
  _backup_scheduler_make_queues
}

_backup_cli_service_cli_start() {
  local RPI_BACKUP_QUEUE_INDEX

  if _backup_scheduler_is_available; then
    _event_script "event-backup-scheduler-before.sh"
    _cli_log_notice "BACKUP SCHEDULER: Executing all processable backup jobs ..."

    # Iterate over jobs in reverse queue order, so that failed jobs are finished before new ones.
    for ((RPI_BACKUP_QUEUE_INDEX = ${#RPI_BACKUP_QUEUE_NAMES[@]} - 1; RPI_BACKUP_QUEUE_INDEX >= 0; RPI_BACKUP_QUEUE_INDEX--)); do
      _backup_scheduler_dequeue "${RPI_BACKUP_QUEUE_NAMES[RPI_BACKUP_QUEUE_INDEX]}"
    done

    _cli_log_notice "BACKUP SCHEDULER: Execution has stopped cleanly."
    _event_script "event-backup-scheduler-after.sh"
  else
    _cli_log_error "BACKUP SCHEDULER: The scheduler is available between ${RPI_BACKUP_SCHEDULER_START_TIME} and ${RPI_BACKUP_SCHEDULER_END_TIME} daily."
  fi
}
