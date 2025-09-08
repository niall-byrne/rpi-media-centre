#!/bin/bash

setup() {
  _mock.create _backup_job_task_tarball_get_new_filename
  _mock.create tar
  _mock.create mv
  _mock.create stdlib.security.path.secure
  _mock.create _cli_log_notice
}

@parametrize_with_tarball_jobs() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_LOCAL_SOURCE;TEST_SVC_USERNAME;TEST_SVC_GROUPNAME;TEST_NEW_FILENAME;TEST_EXISTING_CLEANUP_PATHS_DEFINITION" \
    "simple__no_existing_cleanup_paths;/path/to/source;user1;group1;/path/to/new1.tar;;" \
    "simple__with_existing_cleanup_path;/path/to/source;user1;group1;/path/to/new1.tar;existing_file1|existing_file2"
}

# shellcheck disable=SC2034
test_backup_job_task_tarball_filesystem_build__@vary__calls_get_new_filename_with_correct_args() {
  local RPI_BACKUP_JOB_LOCAL_SOURCE="${TEST_LOCAL_SOURCE}"
  local RPI_EXIT_CLEANUP_PATHS=()
  local RPI_SVC_USERNAME="${TEST_SVC_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_SVC_GROUPNAME}"

  _backup_job_task_tarball_get_new_filename.mock.set.stdout "${TEST_NEW_FILENAME}"

  _backup_job_task_tarball_filesystem_build

  _backup_job_task_tarball_get_new_filename.mock.assert_called_once_with ""
}

@parametrize_with_tarball_jobs \
  test_backup_job_task_tarball_filesystem_build__@vary__calls_get_new_filename_with_correct_args

# shellcheck disable=SC2034
test_backup_job_task_tarball_filesystem_build__@vary__adds_incomplete_to_cleanup_paths() {
  local RPI_BACKUP_JOB_LOCAL_SOURCE="${TEST_LOCAL_SOURCE}"
  local RPI_EXIT_CLEANUP_PATHS=()
  local RPI_SVC_USERNAME="${TEST_SVC_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_SVC_GROUPNAME}"
  local expected_cleanup_paths

  stdlib.array.make.from_string RPI_EXIT_CLEANUP_PATHS "|" "${TEST_EXISTING_CLEANUP_PATHS_DEFINITION}"
  _backup_job_task_tarball_get_new_filename.mock.set.stdout "${TEST_NEW_FILENAME}"
  expected_cleanup_paths=("${RPI_EXIT_CLEANUP_PATHS[@]}" "${TEST_NEW_FILENAME}.incomplete")

  _backup_job_task_tarball_filesystem_build

  assert_array_equals expected_cleanup_paths RPI_EXIT_CLEANUP_PATHS
}

@parametrize_with_tarball_jobs \
  test_backup_job_task_tarball_filesystem_build__@vary__adds_incomplete_to_cleanup_paths

# shellcheck disable=SC2034
test_backup_job_task_tarball_filesystem_build__@vary__logs_notice_message() {
  local RPI_BACKUP_JOB_LOCAL_SOURCE="${TEST_LOCAL_SOURCE}"
  local RPI_EXIT_CLEANUP_PATHS=()
  local RPI_SVC_USERNAME="${TEST_SVC_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_SVC_GROUPNAME}"

  _backup_job_task_tarball_get_new_filename.mock.set.stdout "${TEST_NEW_FILENAME}"

  _backup_job_task_tarball_filesystem_build

  _cli_log_notice.mock.assert_called_once_with \
    "1( -- BACKUP JOB: Creating tarball '${TEST_NEW_FILENAME}' ...)"
}

@parametrize_with_tarball_jobs \
  test_backup_job_task_tarball_filesystem_build__@vary__logs_notice_message

# shellcheck disable=SC2034
test_backup_job_task_tarball_filesystem_build__@vary__calls_tar_with_correct_args() {
  local RPI_BACKUP_JOB_LOCAL_SOURCE="${TEST_LOCAL_SOURCE}"
  local RPI_EXIT_CLEANUP_PATHS=()
  local RPI_SVC_USERNAME="${TEST_SVC_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_SVC_GROUPNAME}"
  local incomplete_filename="${TEST_NEW_FILENAME}.incomplete"
  local expected_basename

  expected_basename="$(basename "${RPI_BACKUP_JOB_LOCAL_SOURCE}")"
  _backup_job_task_tarball_get_new_filename.mock.set.stdout "${TEST_NEW_FILENAME}"

  _backup_job_task_tarball_filesystem_build

  tar.mock.assert_called_once_with \
    "1(cf) 2(${incomplete_filename}) 3(${expected_basename})"
}

@parametrize_with_tarball_jobs \
  test_backup_job_task_tarball_filesystem_build__@vary__calls_tar_with_correct_args

# shellcheck disable=SC2034
test_backup_job_task_tarball_filesystem_build__@vary__calls_mv_with_correct_args() {
  local RPI_BACKUP_JOB_LOCAL_SOURCE="${TEST_LOCAL_SOURCE}"
  local RPI_EXIT_CLEANUP_PATHS=()
  local RPI_SVC_USERNAME="${TEST_SVC_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_SVC_GROUPNAME}"
  local incomplete_filename="${TEST_NEW_FILENAME}.incomplete"

  _backup_job_task_tarball_get_new_filename.mock.set.stdout "${TEST_NEW_FILENAME}"

  _backup_job_task_tarball_filesystem_build

  mv.mock.assert_called_once_with \
    "1(${incomplete_filename}) 2(${TEST_NEW_FILENAME})"
}

@parametrize_with_tarball_jobs \
  test_backup_job_task_tarball_filesystem_build__@vary__calls_mv_with_correct_args

# shellcheck disable=SC2034
test_backup_job_task_tarball_filesystem_build__@vary__calls_path_secure_with_correct_args() {
  local RPI_BACKUP_JOB_LOCAL_SOURCE="${TEST_LOCAL_SOURCE}"
  local RPI_EXIT_CLEANUP_PATHS=()
  local RPI_SVC_USERNAME="${TEST_SVC_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_SVC_GROUPNAME}"

  _backup_job_task_tarball_get_new_filename.mock.set.stdout "${TEST_NEW_FILENAME}"

  _backup_job_task_tarball_filesystem_build

  stdlib.security.path.secure.mock.assert_called_once_with \
    "1(${TEST_NEW_FILENAME}) 2(${TEST_SVC_USERNAME}) 3(${TEST_SVC_GROUPNAME}) 4(600)"
}

@parametrize_with_tarball_jobs \
  test_backup_job_task_tarball_filesystem_build__@vary__calls_path_secure_with_correct_args
