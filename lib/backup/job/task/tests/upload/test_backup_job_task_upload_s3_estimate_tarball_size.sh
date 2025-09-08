#!/bin/bash

setup() {
  _mock.create _cli_log_notice
  _mock.create tar
}

@parametrize_with_source_paths() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_JOB_LOCAL_SOURCE;TEST_TAR_STDOUT;TEST_EXPECTED_SIZE;TEST_EXISTING_OPTIONS_DEFINITION" \
    "simple_path_______existing_options___;/tmp/source_dir/source_file;Total bytes written: 12345 (12KiB, 1.2MiB/s);12345;option1|option2" \
    "simple_path_______no_existing_options;/tmp/source_dir/source_file;Total bytes written: 12345 (12KiB, 1.2MiB/s);12345;;" \
    "path_with_spaces__existing_options___;/home/user/my backup.tar;Total bytes written: 2345 (12KiB, 1.2MiB/s);2345;option1|option2" \
    "path_with_spaces__no_existing_options;/home/user/my backup.tar;Total bytes written: 2345 (12KiB, 1.2MiB/s);2345;;"
}

test_backup_job_task_upload_s3_estimate_tarball_size__@vary__logs_notice() {
  local RPI_BACKUP_JOB_LOCAL_SOURCE="${TEST_JOB_LOCAL_SOURCE}"

  tar.mock.set.stdout ""

  _backup_job_task_upload_s3_estimate_tarball_size

  _cli_log_notice.mock.assert_called_once_with \
    "1( -- BACKUP JOB: Calculating size of '${TEST_JOB_LOCAL_SOURCE}' ...)"
}

@parametrize_with_source_paths \
  test_backup_job_task_upload_s3_estimate_tarball_size__@vary__logs_notice

# shellcheck disable=SC2034
test_backup_job_task_upload_s3_estimate_tarball_size__@vary__appends_expected_size_to_upload_options() {
  local RPI_BACKUP_JOB_LOCAL_SOURCE="${TEST_JOB_LOCAL_SOURCE}"
  local RPI_BACKUP_JOB_UPLOAD_OPTIONS=()
  local expected_options_array

  stdlib.array.make.from_string RPI_BACKUP_JOB_UPLOAD_OPTIONS "|" "${TEST_EXISTING_OPTIONS_DEFINITION}"
  stdlib.array.make.from_string expected_options_array "|" "${TEST_EXISTING_OPTIONS_DEFINITION}"
  expected_options_array+=("--expected-size=${TEST_EXPECTED_SIZE}")

  tar.mock.set.stdout "${TEST_TAR_STDOUT}"

  _backup_job_task_upload_s3_estimate_tarball_size

  assert_array_equals expected_options_array RPI_BACKUP_JOB_UPLOAD_OPTIONS
}

@parametrize_with_source_paths \
  test_backup_job_task_upload_s3_estimate_tarball_size__@vary__appends_expected_size_to_upload_options

# shellcheck disable=SC2034
test_backup_job_task_upload_s3_estimate_tarball_size__@vary__calls_tar_with_correct_args() {
  local RPI_BACKUP_JOB_LOCAL_SOURCE="${TEST_JOB_LOCAL_SOURCE}"
  local RPI_BACKUP_JOB_UPLOAD_OPTIONS=()
  local expected_basename

  expected_basename="$(basename "${TEST_JOB_LOCAL_SOURCE}")"

  tar.mock.set.stdout ""

  _backup_job_task_upload_s3_estimate_tarball_size

  tar.mock.assert_called_once_with \
    "1(--totals) 2(-czf) 3(/dev/null) 4(${expected_basename})"
}

@parametrize_with_source_paths \
  test_backup_job_task_upload_s3_estimate_tarball_size__@vary__calls_tar_with_correct_args
