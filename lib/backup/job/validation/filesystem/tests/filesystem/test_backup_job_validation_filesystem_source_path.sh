#!/bin/bash

setup() {
  _mock.create stdlib.io.path.assert.is_exists
}

@parametrize_with_scenarios() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_PATH" \
    "scenario1;/path/1" \
    "scenario2;/path/2"
}

test_backup_job_validation_filesystem_source_path__@vary__validates_path_exists() {
  _backup_job_validation_filesystem_source_path "${TEST_PATH}"

  stdlib.io.path.assert.is_exists.mock.assert_called_once_with \
    "1(${TEST_PATH})"
}

@parametrize_with_scenarios \
  test_backup_job_validation_filesystem_source_path__@vary__validates_path_exists
