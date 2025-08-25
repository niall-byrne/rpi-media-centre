#!/bin/bash

setup() {
  _mock.create stdlib.io.path.query.is_folder
  _mock.create stdlib.logger.error
}

@parametrize_with_rc() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_RC" \
    "no_args_______________returns_status_code_126;;126" \
    "path_is_not_a_folder__returns_status_code___1;/mock/path;1" \
    "path_is_a_folder______returns_status_code___0;/mock/path;0"
}

@parametrize_with_error_messages() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MOCKED_QUERY_RC;TEST_MESSAGE_ARG_DEFINITION" \
    "no_args_____________;;126;ARGUMENTS_INVALID" \
    "path_is_not_a_folder;/mock/path;1;FS_PATH_IS_NOT_A_FOLDER|/mock/path"
}

test_stdlib_io_path_assert_is_folder__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.io.path.query.is_folder.mock.set.rc "${TEST_RC}"

  _capture.rc stdlib.io.path.assert.is_folder "${args[@]}"

  assert_rc "${TEST_RC}"
}

@parametrize_with_rc \
  test_stdlib_io_path_assert_is_folder__@vary

test_stdlib_io_path_assert_is_folder__@vary__logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"
  stdlib.io.path.query.is_folder.mock.set.rc "${TEST_MOCKED_QUERY_RC}"

  stdlib.io.path.assert.is_folder "${args[@]}" > /dev/null

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.message.get "${message_args[@]}"))"
}

@parametrize_with_error_messages \
  test_stdlib_io_path_assert_is_folder__@vary__logs_an_error
