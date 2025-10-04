#!/bin/bash

# pictl backup manifest help library

set -eo pipefail

_backup_manifest_help() {
  _cli_pretty_highlight "Each line should be a comma separated series of:"
  {
    echo " RPI_BACKUP_JOB_NAME                       |a unique name for the backup job"
    echo " RPI_BACKUP_JOB_GROUP                      |a group for the backup job *(daily, weekly, monthly)"
    echo " RPI_BACKUP_JOB_LOCAL_SOURCE               |the local path to the backup source"
    echo " RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER         |an optional local path to rsync the data to *(--delete is used) *(required when \`RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER\` is blank and \`RPI_BACKUP_JOB_REMOTE_TARGET\` is also blank) *(format this value as a 'path:permission' pair, i.e. /path:0755)"
    echo " RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER       |an optional local path to keep a tarball copy at *(required when \`RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER\` is blank and \`RPI_BACKUP_JOB_REMOTE_TARGET\` is also blank) *(required when \`RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS\` is set) *(format this value as a 'path:permission' pair, i.e. /path:0755)"
    echo " RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS     |an optional count of local tarball versions to keep *(required when \`RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER\` is set)"
    echo " RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH |an optional local path to an encryption key file"
    echo " RPI_BACKUP_JOB_REMOTE_TARGET              |an optional remote target for archival *(required when \`RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER\` is blank and \`RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER\` is also blank)"
    echo " RPI_BACKUP_JOB_REMOTE_PARAMETER           |optional extra parameters for remote archival *(only permitted when \`RPI_BACKUP_JOB_REMOTE_TARGET\` is set)"
  } | _cli_pretty_columns_pipe
}
