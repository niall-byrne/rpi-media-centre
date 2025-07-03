#!/bin/bash

# pictl backup cli library

set -eo pipefail

_backup_cli() {
  # $1: the subcommand to execute

  case "${1}" in
    keyfile-s3)
      _backup_cli_keyfile_s3 "${2}"
      ;;
    recover)
      _backup_cli_recover "${2}" "${3}"
      ;;
    schedule)
      _backup_cli_schedule_jobs "${2}"
      ;;
    service)
      if [[ "${RPI_RUNTIME_ENVIRONMENT}" == "service" ]]; then
        _backup_cli_service_cli "${@:2}"
      else
        {
          _backup_cli_service_restricted
        } >&2
        return 127
      fi
      ;;
    *)
      _backup_cli_usage_error
      ;;
  esac
}

_backup_cli_keyfile_s3() {
  # $1: the filename for the new keyfile

  if [[ -z "${1}" ]]; then
    _backup_cli_usage_error
  fi

  echo "BACKUP SCHEDULER: Generating a new AWS S3 encryption key ..."

  _filesystem_check_does_not_exist "${1}"
  openssl rand 32 > "${1}"
  chmod 400 "${1}"

  echo "BACKUP SCHEDULER: Successfully generated '${1}' !"
}

_backup_cli_recover() {
  # $1: the name of the backup job
  # $2: the local bath to restore it to

  local RPI_BACKUP_JOB_RECOVERY_PATH

  RPI_BACKUP_JOB_RECOVERY_PATH="$(_filesystem_resolve_path_relative_to_cli "${2}")"

  if [[ -z "${RPI_BACKUP_JOB_RECOVERY_PATH}" ]]; then
    _backup_cli_usage_error
  fi

  _backup_job_validation_path "${RPI_BACKUP_JOB_RECOVERY_PATH}"
  _backup_manifest_all_command "_backup_job_task_recover" "" "${1}"
}

_backup_cli_schedule_jobs() {
  # $1: the group of backup jobs to schedule

  if [[ -z "${1}" ]]; then
    _backup_cli_usage_error
  fi

  _control_lock "rpi-backup-scheduler.pid" "15"

  _backup_scheduler_make_queues

  echo "BACKUP SCHEDULER: Scheduling the '${1}' group of backup jobs ..."
  _backup_manifest_all_command "_backup_manifest_write_jobs_all" "${1}"
  echo "BACKUP SCHEDULER: Scheduling complete!"
}

_backup_cli_service_cli() {
  # $1: the subcommand to execute

  case "${1}" in
    job)
      _backup_scheduler_make_queues
      _backup_job "${@:2}"
      ;;
    start)
      _backup_scheduler_make_queues
      _backup_cli_start_service
      ;;
    *)
      _backup_cli_service_cli_usage_error
      ;;
  esac
}

_backup_cli_service_restricted() {
  echo "This command is restricted to the systemd backup service !"
}

_backup_cli_start_service() {
  local RPI_BACKUP_QUEUE_INDEX

  if _backup_scheduler_is_available; then
    _event_script "event-backup-scheduler-begin.sh"
    echo "BACKUP SCHEDULER: Executing all processable backup jobs ..."

    # Iterate over jobs in reverse queue order, so that failed jobs are finished before new ones.
    for ((RPI_BACKUP_QUEUE_INDEX = ${#RPI_BACKUP_QUEUE_NAMES[@]} - 1; RPI_BACKUP_QUEUE_INDEX >= 0; RPI_BACKUP_QUEUE_INDEX--)); do
      _backup_scheduler_dequeue "${RPI_BACKUP_QUEUE_NAMES[RPI_BACKUP_QUEUE_INDEX]}"
    done

    echo "BACKUP SCHEDULER: Execution has stopped cleanly."
    _event_script "event-backup-scheduler-end.sh"
  else
    echo "BACKUP SCHEDULER: The scheduler is available between ${RPI_BACKUP_SCHEDULER_START_TIME} and ${RPI_BACKUP_SCHEDULER_END_TIME} daily."
  fi
}

_backup_cli_service_cli_usage() {
  echo "-- rpi-media-centre backup service manager --"
  echo "Usage:"
  echo -e "\tpictl backup service [SUBCOMMAND]"
  echo -e "\t      job [CONFIGURATION]   - execute the given backup job"
  echo -e "\t      start                 - start the backup scheduler service"
}

_backup_cli_service_cli_usage_error() {
  {
    _backup_cli_service_cli_usage
  } >&2
  return 127
}

_backup_cli_usage() {
  echo "-- rpi-media-centre backup manager --"
  echo "Usage:"
  echo -e "\tpictl backup [SUBCOMMAND]"
  echo -e "\t      keyfile-s3 [FILENAME]  - generate a new encryption keyfile for s3"
  echo -e "\t      recover [NAME] [PATH]  - copy the named remote backup to a local path"
  echo -e "\t      schedule [GROUP]       - schedule a group of backup jobs"
}

_backup_cli_usage_error() {
  {
    _backup_cli_usage
  } >&2
  return 127
}
