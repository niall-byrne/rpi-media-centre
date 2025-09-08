#!/bin/bash

# pictl testing backup fixtures

set -eo pipefail

fake_manifest_n_entries() {
  # $1: the number of entries to create

  local FAKE_MANIFEST_INDEX

  for ((FAKE_MANIFEST_INDEX = 0; FAKE_MANIFEST_INDEX < "${1}"; FAKE_MANIFEST_INDEX++)); do
    RPI_BACKUP_JOBS_NAMES+=("job_name${FAKE_MANIFEST_INDEX}")
    RPI_BACKUP_JOBS_GROUPS+=("job_group${FAKE_MANIFEST_INDEX}")
    RPI_BACKUP_JOBS_LOCAL_SOURCES+=("/path/source${FAKE_MANIFEST_INDEX}")
    RPI_BACKUP_JOBS_LOCAL_RSYNC_FOLDERS+=("/path/rsync${FAKE_MANIFEST_INDEX}")
    RPI_BACKUP_JOBS_LOCAL_TARBALL_FOLDERS+=("/path/tarball${FAKE_MANIFEST_INDEX}")
    RPI_BACKUP_JOBS_LOCAL_TARBALL_VERSIONS+=($(("${FAKE_MANIFEST_INDEX}" + 1)))
    RPI_BACKUP_JOBS_REMOTE_ENCRYPTION_KEY_PATHS+=("/path/${FAKE_MANIFEST_INDEX}.key")
    RPI_BACKUP_JOBS_REMOTE_TARGETS+=("s3://bucket${FAKE_MANIFEST_INDEX}")
    RPI_BACKUP_JOBS_REMOTE_PARAMETERS+=("GLACIER")
  done
}

# shellcheck disable=SC2034
fake_backup_job_n() {
  # $1: an optional index
  # $2: an optional group index

  local FAKE_MANIFEST_INDEX="${1:0}"
  local FAKE_MANIFEST_GROUP_INDEX="${2:-0}"

  RPI_BACKUP_JOB_NAME="job_name${FAKE_MANIFEST_INDEX}"
  RPI_BACKUP_JOB_GROUP="job_group${FAKE_MANIFEST_GROUP_INDEX}"
  RPI_BACKUP_JOB_LOCAL_SOURCE="/path/source${FAKE_MANIFEST_INDEX}"
  RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER="/path/rsync${FAKE_MANIFEST_INDEX}"
  RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER="/path/tarball${FAKE_MANIFEST_INDEX}"
  RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS="$(("${FAKE_MANIFEST_INDEX}" + 1))"
  RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH="/path/${FAKE_MANIFEST_INDEX}.key"
  RPI_BACKUP_JOB_REMOTE_TARGET="s3://bucket${FAKE_MANIFEST_INDEX}"
  RPI_BACKUP_JOB_REMOTE_PARAMETER="GLACIER"
}

_create_fake_job_n_log_entries() {
  # $1: the number of log entries to create
  # $2: an optional start index
  # $3: an optional group start index
  # $4: an optional value to limit groups to

  local FAKE_MANIFEST_INDEX
  local FAKE_MANIFEST_GROUP_INDEX="${3:-0}"
  local FAKE_MANIFEST_GROUP_LIMIT="${4:-0}"

  # shellcheck disable=SC2034
  for ((FAKE_MANIFEST_INDEX = ${2:-0}; FAKE_MANIFEST_INDEX < "${1}" + " ${2:-0}"; FAKE_MANIFEST_INDEX++)); do
    fake_backup_job_n "${FAKE_MANIFEST_INDEX}" "${FAKE_MANIFEST_GROUP_INDEX}"
    _backup_job_log

    if [[ "${FAKE_MANIFEST_GROUP_LIMIT}" -gt "0" ]] &&
      ((FAKE_MANIFEST_GROUP_LIMIT < FAKE_MANIFEST_GROUP_INDEX + FAKE_MANIFEST_GROUP_LIMIT)); then
      ((FAKE_MANIFEST_GROUP_INDEX += 1))
    else
      ((FAKE_MANIFEST_GROUP_INDEX += 1))
    fi
  done
}
