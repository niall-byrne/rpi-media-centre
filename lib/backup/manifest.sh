#!/bin/bash

# pictl backup manifest library

set -eo pipefail

_backup_manifest_all_command() {
  # $1: the command to execute on all jobs
  # $2: an optional group to filter jobs by
  # $3: an optional name to filter jobs by

  local RPI_BACKUP_JOBS_INDEX
  local RPI_BACKUP_JOBS_NAMES=()
  local RPI_BACKUP_JOBS_GROUPS=()
  local RPI_BACKUP_JOBS_LOCAL_SOURCES=()
  local RPI_BACKUP_JOBS_LOCAL_RSYNC_FOLDERS=()
  local RPI_BACKUP_JOBS_LOCAL_TARBALL_FOLDERS=()
  local RPI_BACKUP_JOBS_LOCAL_TARBALL_VERSIONS=()
  local RPI_BACKUP_JOBS_REMOTE_ENCRYPTION_KEY_PATHS=()
  local RPI_BACKUP_JOBS_REMOTE_TARGETS=()
  local RPI_BACKUP_JOBS_REMOTE_PARAMETERS=()

  _backup_manifest_load

  for ((RPI_BACKUP_JOBS_INDEX = 0; RPI_BACKUP_JOBS_INDEX < "${#RPI_BACKUP_JOBS_NAMES[@]}"; RPI_BACKUP_JOBS_INDEX++)); do

    if [[ -n "${2}" ]] &&
      [[ "${2}" != "${RPI_BACKUP_JOBS_GROUPS[RPI_BACKUP_JOBS_INDEX]}" ]]; then
      continue
    fi

    if [[ -n "${3}" ]] &&
      [[ "${3}" != "${RPI_BACKUP_JOBS_NAMES[RPI_BACKUP_JOBS_INDEX]}" ]]; then
      continue
    fi

    __backup_manifest_all_command_wrapper "${1}" \
      "${RPI_BACKUP_JOBS_NAMES[RPI_BACKUP_JOBS_INDEX]}" \
      "${RPI_BACKUP_JOBS_GROUPS[RPI_BACKUP_JOBS_INDEX]}" \
      "${RPI_BACKUP_JOBS_LOCAL_SOURCES[RPI_BACKUP_JOBS_INDEX]}" \
      "${RPI_BACKUP_JOBS_LOCAL_RSYNC_FOLDERS[RPI_BACKUP_JOBS_INDEX]}" \
      "${RPI_BACKUP_JOBS_LOCAL_TARBALL_FOLDERS[RPI_BACKUP_JOBS_INDEX]}" \
      "${RPI_BACKUP_JOBS_LOCAL_TARBALL_VERSIONS[RPI_BACKUP_JOBS_INDEX]}" \
      "${RPI_BACKUP_JOBS_REMOTE_ENCRYPTION_KEY_PATHS[RPI_BACKUP_JOBS_INDEX]}" \
      "${RPI_BACKUP_JOBS_REMOTE_TARGETS[RPI_BACKUP_JOBS_INDEX]}" \
      "${RPI_BACKUP_JOBS_REMOTE_PARAMETERS[RPI_BACKUP_JOBS_INDEX]}"

  done
}

__backup_manifest_all_command_wrapper() {
  local RPI_BACKUP_MANIFEST_ALL_COMMAND="${1}"
  local RPI_BACKUP_JOB_NAME="${2}"
  local RPI_BACKUP_JOB_GROUP="${3}"
  local RPI_BACKUP_JOB_LOCAL_SOURCE="${4}"
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER="${5}"
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER="${6}"
  local RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS="${7}"
  local RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH="${8}"
  local RPI_BACKUP_JOB_REMOTE_TARGET="${9}"
  local RPI_BACKUP_JOB_REMOTE_PARAMETER="${10}"

  "${RPI_BACKUP_MANIFEST_ALL_COMMAND}"
}

_backup_manifest_help() {
  _cli_pretty_highlight "Each line should be a comma separated series of:"
  {
    echo " RPI_BACKUP_JOB_NAME                       |a unique name for the backup job"
    echo " RPI_BACKUP_JOB_GROUP                      |a group for the backup job *(daily, weekly, monthly)"
    echo " RPI_BACKUP_JOB_LOCAL_SOURCE               |the local path to the backup source"
    echo " RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER         |an optional local path to rsync the data to *(--delete is used) *(required when \`RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER\` is blank and \`RPI_BACKUP_JOB_REMOTE_TARGET\` is also blank)"
    echo " RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER       |an optional local path to keep a tarball copy at *(required when \`RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER\` is blank and \`RPI_BACKUP_JOB_REMOTE_TARGET\` is also blank) *(required when \`RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS\` is set)"
    echo " RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS     |an optional count of local tarball versions to keep *(required when \`RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER\` is set)"
    echo " RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH |an optional local path to an encryption key file"
    echo " RPI_BACKUP_JOB_REMOTE_TARGET              |an optional remote target for archival *(required when \`RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER\` is blank and \`RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER\` is also blank)"
    echo " RPI_BACKUP_JOB_REMOTE_PARAMETER           |optional extra parameters for remote archival *(only permitted when \`RPI_BACKUP_JOB_REMOTE_TARGET\` is set)"
  } | _cli_pretty_columns_pipe
}

_backup_manifest_line_invalid() {
  {
    echo "The ${RPI_MANIFEST_BACKUP} file is improperly formatted!"
    echo "Input Line: ${FILE_LINE}"
    _backup_job_log
    _backup_manifest_help
  } >&2 # KCOV_EXCLUDE_LINE
  return 127
}

_backup_manifest_line_log_all() {
  _cli_log_notice "== Start of Job '${RPI_BACKUP_JOB_NAME}' =="
  _backup_job_log
  _cli_log_notice "== End of Job '${RPI_BACKUP_JOB_NAME}' =="
}

_backup_manifest_load() {
  local FILE_LINE
  local RPI_BACKUP_JOB_INDEX
  local RPI_BACKUP_JOB_NAME
  local RPI_BACKUP_JOB_GROUP
  local RPI_BACKUP_JOB_LOCAL_SOURCE
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER
  local RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS
  local RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH
  local RPI_BACKUP_JOB_REMOTE_TARGET
  local RPI_BACKUP_JOB_REMOTE_PARAMETER

  _cli_log_notice "-- loading ${RPI_MANIFEST_BACKUP} file ... --"

  if ! stdlib.io.path.query.is_exists "${RPI_MANIFEST_BACKUP}"; then
    _cli_log_error "Please create the ${RPI_MANIFEST_BACKUP} file to use this feature."
    {
      _backup_manifest_help
    } >&2 # KCOV_EXCLUDE_LINE
    return 127
  fi

  stdlib.security.path.query.is_secure "${RPI_MANIFEST_BACKUP}" "root" "root" "600"

  while IFS= read -r FILE_LINE; do

    # Ignore comments
    if [[ "${FILE_LINE:0:1}" == "#" ]]; then
      continue
    fi

    # Ignore blank lines
    if [[ "${FILE_LINE}" == "" ]]; then
      continue
    fi

    IFS="," read -r \
      RPI_BACKUP_JOB_NAME \
      RPI_BACKUP_JOB_GROUP \
      RPI_BACKUP_JOB_LOCAL_SOURCE \
      RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER \
      RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER \
      RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS \
      RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH \
      RPI_BACKUP_JOB_REMOTE_TARGET \
      RPI_BACKUP_JOB_REMOTE_PARAMETER \
      <<< "$FILE_LINE"

    _backup_job_validation "_backup_manifest_line_invalid"

    for ((RPI_BACKUP_JOB_INDEX = 0; RPI_BACKUP_JOB_INDEX < "${#RPI_BACKUP_JOBS_NAMES[@]}"; RPI_BACKUP_JOB_INDEX++)); do
      if [[ "${RPI_BACKUP_JOBS_NAMES["${RPI_BACKUP_JOB_INDEX}"]}" == "${RPI_BACKUP_JOB_NAME}" ]]; then
        _cli_log_error "The backup job name '${RPI_BACKUP_JOB_NAME}' is used multiple times, this value must be unique."
        _backup_manifest_line_invalid
      fi
    done

    RPI_BACKUP_JOBS_NAMES+=("${RPI_BACKUP_JOB_NAME}")
    RPI_BACKUP_JOBS_GROUPS+=("${RPI_BACKUP_JOB_GROUP}")
    RPI_BACKUP_JOBS_LOCAL_SOURCES+=("${RPI_BACKUP_JOB_LOCAL_SOURCE}")
    RPI_BACKUP_JOBS_LOCAL_RSYNC_FOLDERS+=("${RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER}")
    RPI_BACKUP_JOBS_LOCAL_TARBALL_FOLDERS+=("${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}")
    RPI_BACKUP_JOBS_LOCAL_TARBALL_VERSIONS+=("${RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS}")
    RPI_BACKUP_JOBS_REMOTE_ENCRYPTION_KEY_PATHS+=("${RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH}")
    RPI_BACKUP_JOBS_REMOTE_TARGETS+=("${RPI_BACKUP_JOB_REMOTE_TARGET}")
    RPI_BACKUP_JOBS_REMOTE_PARAMETERS+=("${RPI_BACKUP_JOB_REMOTE_PARAMETER}")

  done < "${RPI_MANIFEST_BACKUP}" # KCOV_EXCLUDE_LINE
}

_backup_manifest_write_jobs_all() {
  local RPI_BACKUP_INITIAL_QUEUE="${RPI_BACKUP_QUEUE_NAMES[0]}"
  local RPI_BACKUP_PATH_NEW_JOB="${RPI_BACKUP_PATH_QUEUE_ROOT}/${RPI_BACKUP_INITIAL_QUEUE}/${RPI_BACKUP_JOB_NAME}"

  local RPI_BACKUP_JOB_DATA="
    -n \"${RPI_BACKUP_JOB_NAME}\"
    -s \"${RPI_BACKUP_JOB_LOCAL_SOURCE}\"
    -r \"${RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER}\"
    -b \"${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}\"
    -v \"${RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS}\"
    -k \"${RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH}\"
    -t \"${RPI_BACKUP_JOB_REMOTE_TARGET}\"
    -p \"${RPI_BACKUP_JOB_REMOTE_PARAMETER}\"
  "

  RPI_BACKUP_JOB_DATA="${RPI_BACKUP_JOB_DATA//$'\n'"    "/" "}"
  RPI_BACKUP_JOB_DATA="${RPI_BACKUP_JOB_DATA//$'\n'/""}"

  eval "_backup_job_args ${RPI_BACKUP_JOB_DATA} -q ${RPI_BACKUP_QUEUE_NAMES[0]}"

  {
    echo "#!/bin/bash"
    echo "pictl backup service job ${RPI_BACKUP_JOB_DATA} -q \"\${1}\""
  } > "${RPI_BACKUP_PATH_NEW_JOB}" # KCOV_EXCLUDE_LINE

  stdlib.security.path.secure "${RPI_BACKUP_PATH_NEW_JOB}" "root" "root" "700"
}
