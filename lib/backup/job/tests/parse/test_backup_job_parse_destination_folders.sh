#!/bin/bash

setup() {
  _mock.create _backup_job_parse_destination_folder_and_permission
}

@parametrize_with_destination_folders() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_BACKUP_JOB_LOCAL_TARBALL_FOLDER;TEST_BACKUP_JOB_LOCAL_RSYNC_FOLDER" \
    "tarball_____no_rsync;/tarball:755;;" \
    "tarball_____rsync___;/tarball:755;/rsync:0750" \
    "no_tarball__rsync___;;/rsync:0750" \
    "no_tarball__no_rsync;;;"
}

# shellcheck disable=SC2034
test_backup_job_parse_destination_folders__calls_parse_destination_folder_and_permission() {
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER="${TEST_BACKUP_JOB_LOCAL_TARBALL_FOLDER}"
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER="${TEST_BACKUP_JOB_LOCAL_RSYNC_FOLDER}"

  _backup_job_parse_destination_folders

  _backup_job_parse_destination_folder_and_permission.mock.assert_calls_are \
    "1(${TEST_BACKUP_JOB_LOCAL_TARBALL_FOLDER}) 2(RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER) 3(RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER_PERMISSION)" \
    "1(${TEST_BACKUP_JOB_LOCAL_RSYNC_FOLDER}) 2(RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER) 3(RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER_PERMISSION)"
}
