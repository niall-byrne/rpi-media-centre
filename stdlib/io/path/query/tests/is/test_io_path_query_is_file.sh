#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
  _mock.create test

  _STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN=1
}

@parametrize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "too_many_args______127;arg1|arg2;127" \
    "insufficient_args__127;;127" \
    "empty_arg__________126;|;126"
}

test_stdlib_io_path_query_is_file__@vary__________return_expected_status_code() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.io.path.query.is_file "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_io_path_query_is_file__@vary__________return_expected_status_code

test_stdlib_io_path_query_is_file__valid_args_________test_passes__return_status_code_0() {
  test.mock.set.rc "0"

  _capture.rc stdlib.io.path.query.is_file "/some/file"

  assert_rc "0"
}

test_stdlib_io_path_query_is_file__valid_args_________test_fails___return_status_code_1() {
  test.mock.set.rc "1"

  _capture.rc stdlib.io.path.query.is_file "/some/file"

  assert_rc "1"
}

test_stdlib_io_path_query_is_file__valid_args_________test_is_called_with_expected_args() {
  stdlib.io.path.query.is_file "/some/file"

  test.mock.assert_called_once_with "1(-f) 2(/some/file)"
}
