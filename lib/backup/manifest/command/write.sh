#!/bin/bash

# pictl backup manifest command write library

set -eo pipefail

_backup_manifest_command_write_job() {
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

  {
    echo "#!/bin/bash"
    echo "pictl backup service job ${RPI_BACKUP_JOB_DATA} -q \"\${1}\""
  } > "${RPI_BACKUP_PATH_NEW_JOB}" # KCOV_EXCLUDE_LINE

  stdlib.security.path.secure "${RPI_BACKUP_PATH_NEW_JOB}" "root" "root" "700"
}
