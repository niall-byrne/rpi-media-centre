#!/bin/bash

setup() {
  _mock.create stdlib.io.path.query.is_exists
  _mock.create stdlib.logger.error
}

@parametrize_with_rc() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MOCKED_QUERY_RC;TEST_RC" \
    "no_args______________returns_status_code_126;;126;126" \
    "path_exists__________returns_status_code___1;/mock/path;0;1" \
    "path_does_not_exist__returns_status_code___0;/mock/path;1;0"
}

@parametrize_with_error_messages() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MOCKED_QUERY_RC;TEST_MESSAGE_ARG_DEFINITION" \
    "no_args____________;;126;ARGUMENTS_INVALID" \
    "path_exists________;/mock/path;0;FS_PATH_EXISTS|/mock/path"
}

test_stdlib_io_path_assert_not_exists__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.io.path.query.is_exists.mock.set.rc "${TEST_MOCKED_QUERY_RC}"

  _capture.rc stdlib.io.path.assert.not_exists "${args[@]}"

  assert_rc "${TEST_RC}"
}

@parametrize_with_rc \
  test_stdlib_io_path_assert_not_exists__@vary

test_stdlib_io_path_assert_not_exists__@vary__logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"
  stdlib.io.path.query.is_exists.mock.set.rc "${TEST_MOCKED_QUERY_RC}"

  stdlib.io.path.assert.not_exists "${args[@]}" > /dev/null

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.message.get "${message_args[@]}"))"
}

@parametrize_with_error_messages \
  test_stdlib_io_path_assert_not_exists__@vary__logs_an_error
