#!/bin/bash

setup() {
  _mock.create _backup_job_task_tarball_filesystem_clean
  _mock.create _control_pushd
  _mock.create _backup_job_task_tarball_filesystem_prune
}

@parametrize_with_paths() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_LOCAL_SOURCE" \
    "simple_path____;/path/to/source" \
    "path_with_spaces;/a/path with spaces"
}

test_backup_job_task_tarball_filesystem__@vary__calls_clean_with_correct_args() {
  local RPI_BACKUP_JOB_LOCAL_SOURCE="${TEST_LOCAL_SOURCE}"

  _backup_job_task_tarball_filesystem

  _backup_job_task_tarball_filesystem_clean.mock.assert_called_once_with ""
}

@parametrize_with_paths \
  test_backup_job_task_tarball_filesystem__@vary__calls_clean_with_correct_args

test_backup_job_task_tarball_filesystem__@vary__calls_pushd_with_correct_args() {
  local RPI_BACKUP_JOB_LOCAL_SOURCE="${TEST_LOCAL_SOURCE}"
  local expected_dirname

  expected_dirname="$(dirname "${RPI_BACKUP_JOB_LOCAL_SOURCE}")"

  _backup_job_task_tarball_filesystem

  _control_pushd.mock.assert_called_once_with "1(${expected_dirname}) 2(_backup_job_task_tarball_filesystem_build)"
}

@parametrize_with_paths \
  test_backup_job_task_tarball_filesystem__@vary__calls_pushd_with_correct_args

test_backup_job_task_tarball_filesystem__@vary__calls_prune_with_correct_args() {
  local RPI_BACKUP_JOB_LOCAL_SOURCE="${TEST_LOCAL_SOURCE}"

  _backup_job_task_tarball_filesystem

  _backup_job_task_tarball_filesystem_prune.mock.assert_called_once_with ""
}

@parametrize_with_paths \
  test_backup_job_task_tarball_filesystem__@vary__calls_prune_with_correct_args
