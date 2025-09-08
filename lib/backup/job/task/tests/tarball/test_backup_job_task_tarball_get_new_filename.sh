#!/bin/bash

setup() {
  _mock.create date
}

@parametrize_with_tarball_jobs() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_TARBALL_FOLDER;TEST_JOB_NAME;TEST_TIMESTAMP" \
    "simple;/path/to/tarballs;job1;2023-10-27_10-00-00" \
    "complex;/path with spaces;job name with spaces;2023-10-28_11-30-00"
}

# shellcheck disable=SC2034
test_backup_job_task_tarball_get_new_filename__@vary__returns_correct_filename() {
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER="${TEST_TARBALL_FOLDER}"
  local RPI_BACKUP_JOB_NAME="${TEST_JOB_NAME}"

  date.mock.set.stdout "${TEST_TIMESTAMP}"

  _capture.output _backup_job_task_tarball_get_new_filename

  assert_output \
    "${TEST_TARBALL_FOLDER}/${TEST_JOB_NAME}_${TEST_TIMESTAMP}.tar"
}

@parametrize_with_tarball_jobs \
  test_backup_job_task_tarball_get_new_filename__@vary__returns_correct_filename

# shellcheck disable=SC2034
test_backup_job_task_tarball_get_new_filename__@vary__calls_date_properly() {
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER="${TEST_TARBALL_FOLDER}"
  local RPI_BACKUP_JOB_NAME="${TEST_JOB_NAME}"

  _backup_job_task_tarball_get_new_filename > /dev/null

  date.mock.assert_called_once_with "1(+%Y-%m-%d_%H-%M-%S)"
}

@parametrize_with_tarball_jobs \
  test_backup_job_task_tarball_get_new_filename__@vary__calls_date_properly
