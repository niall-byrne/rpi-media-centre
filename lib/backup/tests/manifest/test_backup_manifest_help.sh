#!/bin/bash

setup() {
  _fixture_mock_pretty
}

test_backup_manifest_help__creates_a_highlighted_line() {
  _backup_manifest_help

  _cli_pretty_highlight.mock.assert_called_once_with \
    "1(Each line should be a comma separated series of:)"
}

test_backup_manifest_help__creates_columned_data() {
  _backup_manifest_help

  _cli_pretty_columns_pipe.mock.assert_called_once_with \
    "1( RPI_BACKUP_JOB_NAME                       |a unique name for the backup job
 RPI_BACKUP_JOB_GROUP                      |a group for the backup job *(daily, weekly, monthly)
 RPI_BACKUP_JOB_LOCAL_SOURCE               |the local path to the backup source
 RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER         |an optional local path to rsync the data to *(--delete is used) *(required when \`RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER\` is blank and \`RPI_BACKUP_JOB_REMOTE_TARGET\` is also blank)
 RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER       |an optional local path to keep a tarball copy at *(required when \`RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER\` is blank and \`RPI_BACKUP_JOB_REMOTE_TARGET\` is also blank) *(required when \`RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS\` is set)
 RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS     |an optional count of local tarball versions to keep *(required when \`RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER\` is set)
 RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH |an optional local path to an encryption key file
 RPI_BACKUP_JOB_REMOTE_TARGET              |an optional remote target for archival *(required when \`RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER\` is blank and \`RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER\` is also blank)
 RPI_BACKUP_JOB_REMOTE_PARAMETER           |optional extra parameters for remote archival *(only permitted when \`RPI_BACKUP_JOB_REMOTE_TARGET\` is set))"
}

test_backup_manifest_help__outputs_expected_data() {
  _cli_pretty_highlight.mock.set.stdout "expected output1"
  _cli_pretty_columns_pipe.mock.set.stdout "expected output2"

  _capture.stdout _backup_manifest_help

  assert_output "expected output1"$'\n'"expected output2"
}
