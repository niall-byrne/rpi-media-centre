#!/bin/bash

# pictl backup manifest line library

set -eo pipefail

_backup_manifest_line_log_all() {
  _cli_log_notice "== Start of Job '${RPI_BACKUP_JOB_NAME}' =="
  _backup_job_log
  _cli_log_notice "== End of Job '${RPI_BACKUP_JOB_NAME}' =="
}

_backup_manifest_line_log_invalid() {
  {
    echo "The ${RPI_MANIFEST_BACKUP} file is improperly formatted!"
    echo "Input Line: ${FILE_LINE}"
    _backup_job_log
    _backup_manifest_help
  } >&2 # KCOV_EXCLUDE_LINE
  return 127
}

_backup_manifest_line_validate() {
  (
    _backup_job_parse_destination_folders
    _backup_job_validation "_backup_manifest_line_log_invalid"
  )
}
