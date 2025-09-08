#!/bin/bash

setup() {
  _mock.create stdlib.io.path.assert.is_folder
  _mock.create stdlib.security.path.query.is_secure
}

@parametrize_with_service() {
  # $1: the test function to parametrize

  @parametrize \
    "$1" \
    "RPI_RUNTIME_ENVIRONMENT;TEST_PATH;RPI_SVC_USERNAME;RPI_SVC_GROUPNAME" \
    "path_1;service;path1;user1;group1" \
    "path_2;service;path2;user2;group2"
}

@parametrize_with_cli() {
  # $1: the test function to parametrize

  @parametrize \
    "$1" \
    "RPI_RUNTIME_ENVIRONMENT;TEST_PATH;RPI_SVC_USERNAME;RPI_SVC_GROUPNAME" \
    "path_1;cli;path1;user1;group1" \
    "path_2;cli;path2;user2;group2"
}

test_backup_job_validation_path__@vary__@vary__calls_is_folder() {
  _backup_job_validation_path "${TEST_PATH}"

  stdlib.io.path.assert.is_folder.mock.assert_called_once_with \
    "1(${TEST_PATH})"
}

@parametrize.apply \
  test_backup_job_validation_path__@vary__@vary__calls_is_folder \
  @parametrize_with_service \
  @parametrize_with_cli

test_backup_job_validation_path__cli______@vary__calls_is_secure() {
  _backup_job_validation_path "${TEST_PATH}"

  stdlib.security.path.query.is_secure.mock.assert_called_once_with \
    "1(${TEST_PATH}) 2(${RPI_SVC_USERNAME}) 3(${RPI_SVC_GROUPNAME}) 4(700)"
}

@parametrize_with_cli \
  test_backup_job_validation_path__cli______@vary__calls_is_secure

test_backup_job_validation_path__service__@vary__does_not_call_is_secure() {
  _backup_job_validation_path "${TEST_PATH}"

  stdlib.security.path.query.is_secure.mock.assert_not_called
}

@parametrize_with_service \
  test_backup_job_validation_path__service__@vary__does_not_call_is_secure
