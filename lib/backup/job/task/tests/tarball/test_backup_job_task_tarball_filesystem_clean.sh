#!/bin/bash

setup() {
  _mock.create rm
}

@parametrize_with_paths() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_TARBALL_FOLDER" \
    "simple_path_____;/path/to/tarballs" \
    "path_with_spaces;/a/path with spaces"
}

# shellcheck disable=SC2034
test_backup_job_task_tarball_filesystem_clean__@vary__calls_rm_with_correct_args() {
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER="${TEST_TARBALL_FOLDER}"

  _backup_job_task_tarball_filesystem_clean

  rm.mock.assert_called_once_with \
    "1(-f) 2(${TEST_TARBALL_FOLDER}/*_[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]_[0-9][0-9]-[0-9][0-9]-[0-9][0-9].tar.incomplete)"
}

@parametrize_with_paths \
  test_backup_job_task_tarball_filesystem_clean__@vary__calls_rm_with_correct_args
