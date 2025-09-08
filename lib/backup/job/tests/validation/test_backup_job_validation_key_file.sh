#!/bin/bash

setup() {
  _mock.create stdlib.io.path.assert.is_file
  _mock.create stdlib.security.path.assert.is_secure
}

@parametrize_with_paths() {
  # $1: the test function to parametrize

  @parametrize \
    "$1" \
    "TEST_PATH" \
    "simple_path____________;test_path" \
    "path_with_spaces_______;a path with spaces" \
    "path_with_special_chars;a/path/with/special/chars"
}

test_backup_job_validation_key_file__@vary__calls_is_file() {
  _backup_job_validation_key_file "${TEST_PATH}"

  stdlib.io.path.assert.is_file.mock.assert_called_once_with \
    "1(${TEST_PATH})"
}

@parametrize_with_paths \
  test_backup_job_validation_key_file__@vary__calls_is_file

test_backup_job_validation_key_file__@vary__calls_is_secure() {
  _backup_job_validation_key_file "${TEST_PATH}"

  stdlib.security.path.assert.is_secure.mock.assert_called_once_with \
    "1(${TEST_PATH}) 2(root) 3(root) 4(400)"
}

@parametrize_with_paths \
  test_backup_job_validation_key_file__@vary__calls_is_secure
