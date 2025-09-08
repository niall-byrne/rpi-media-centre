#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/backup/job/task/tests/tarball/__fixtures__/tarball_file_listing.sh"

setup() {
  _mock.create ls
}

@parametrize_with_ls_output() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_NUM_FILES;TEST_TARBALL_FOLDER;TEST_JOB_NAME" \
    "3_files;3;/path/to/tarballs;job1" \
    "5_files;5;/another/path;job2"
}

test_backup_job_task_tarball_get_latest_filename__@vary__returns_correct_filename() {
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER="${TEST_TARBALL_FOLDER}"
  local RPI_BACKUP_JOB_NAME="${TEST_JOB_NAME}"
  local ls_output
  local expected_filename
  local actual_filename

  ls_output="$(_fixture_generate_ls_output "${TEST_NUM_FILES}" "${TEST_TARBALL_FOLDER}" "${TEST_JOB_NAME}")"
  ls.mock.set.stdout "${ls_output}"
  expected_filename="$(echo "${ls_output}" | head -n1)"

  actual_filename="$(_backup_job_task_tarball_get_latest_filename)"

  assert_equals "${expected_filename}" "${actual_filename}"
}

@parametrize_with_ls_output \
  test_backup_job_task_tarball_get_latest_filename__@vary__returns_correct_filename

# shellcheck disable=SC2034
test_backup_job_task_tarball_get_latest_filename__@vary__calls_ls_with_correct_args() {
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER="${TEST_TARBALL_FOLDER}"
  local RPI_BACKUP_JOB_NAME="${TEST_JOB_NAME}"

  _backup_job_task_tarball_get_latest_filename

  ls.mock.assert_called_once_with \
    "1(-t1) 2(${TEST_TARBALL_FOLDER}/${TEST_JOB_NAME}_[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]_[0-9][0-9]-[0-9][0-9]-[0-9][0-9].tar)"
}

@parametrize_with_ls_output \
  test_backup_job_task_tarball_get_latest_filename__@vary__calls_ls_with_correct_args
