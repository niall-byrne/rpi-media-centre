#!/bin/bash

setup() {
  _mock.create stdlib.io.path.query.is_exists
}

@parametrize_with_paths_and_rcs() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_PATH;TEST_EXPECTED_RC" \
    "simple_path_success;/path/to/source;0" \
    "path_with_spaces_success;/another/path with spaces;0" \
    "simple_path_failure;/path/to/source;1" \
    "path_with_spaces_failure;/another/path with spaces;1"
}

test_backup_job_validation_source__@vary__returns_correct_rc() {
  stdlib.io.path.query.is_exists.mock.set.rc "${TEST_EXPECTED_RC}"

  _capture.rc _backup_job_validation_source "${TEST_PATH}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_paths_and_rcs \
  test_backup_job_validation_source__@vary__returns_correct_rc

test_backup_job_validation_source__@vary__calls_is_exists_with_correct_args() {
  stdlib.io.path.query.is_exists.mock.set.rc "${TEST_EXPECTED_RC}"

  _backup_job_validation_source "${TEST_PATH}"

  stdlib.io.path.query.is_exists.mock.assert_called_once_with \
    "1(${TEST_PATH})"
}

@parametrize_with_paths_and_rcs \
  test_backup_job_validation_source__@vary__calls_is_exists_with_correct_args
