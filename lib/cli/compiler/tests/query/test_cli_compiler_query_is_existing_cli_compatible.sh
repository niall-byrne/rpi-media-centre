#!/bin/bash

setup() {
  _mock.create stdlib.io.path.query.is_file
}

@parametrize_with_file_existence() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_FILE_EXISTS_RC;TEST_EXPECTED_RC;TEST_EXPECTED_OUTPUT;TEST_PATH_COMPILED_CLI" \
    "file_exists;0;0;;/tmp/cli.sh" \
    "file_does_not_exist;1;1;No existing CLI, compiling ...;/tmp/cli.sh"
}

# shellcheck disable=SC2034
test_cli_compiler_query_is_existing_cli_compatible__@vary__calls_is_file_correctly() {
  local RPI_PATH_COMPILED_CLI="${TEST_PATH_COMPILED_CLI}"
  stdlib.io.path.query.is_file.mock.set.rc "${TEST_FILE_EXISTS_RC}"

  _cli_compiler_query_is_existing_cli_compatible > /dev/null

  stdlib.io.path.query.is_file.mock.assert_called_once_with \
    "1(${TEST_PATH_COMPILED_CLI})"
}

@parametrize_with_file_existence \
  test_cli_compiler_query_is_existing_cli_compatible__@vary__calls_is_file_correctly

# shellcheck disable=SC2034
test_cli_compiler_query_is_existing_cli_compatible__@vary__returns_expected_rc() {
  local RPI_PATH_COMPILED_CLI="${TEST_PATH_COMPILED_CLI}"
  stdlib.io.path.query.is_file.mock.set.rc "${TEST_FILE_EXISTS_RC}"

  _capture.rc _cli_compiler_query_is_existing_cli_compatible > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_file_existence \
  test_cli_compiler_query_is_existing_cli_compatible__@vary__returns_expected_rc

# shellcheck disable=SC2034
test_cli_compiler_query_is_existing_cli_compatible__@vary__echos_correct_message() {
  local RPI_PATH_COMPILED_CLI="${TEST_PATH_COMPILED_CLI}"
  stdlib.io.path.query.is_file.mock.set.rc "${TEST_FILE_EXISTS_RC}"

  _capture.stdout _cli_compiler_query_is_existing_cli_compatible

  assert_equals "${TEST_EXPECTED_OUTPUT}" "${TEST_OUTPUT}"
}

@parametrize_with_file_existence \
  test_cli_compiler_query_is_existing_cli_compatible__@vary__echos_correct_message
