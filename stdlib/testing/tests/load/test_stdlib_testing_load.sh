#!/bin/bash

setup() {
  _mock.create _testing.error
  _testing.error.mock.set.rc "127"
}

@parametrize_with_invalid_args() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION,TEST_EXPECTED_RC,TEST_EXPECTED_ERROR_MESSAGE" \
    "no_args_______127,,127,_testing.load: Invalid arguments!" \
    "extra_arg_____127,non-existent_target.sh|extra_arg,127,_testing.load: Invalid arguments!"
}

test_stdlib_testing_load__@vary__returns_expected_status_code() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _testing.load "${args[@]}" > /dev/null

  assert_equals "${TEST_EXPECTED_RC}" "$?"
}

@parametrize_with_invalid_args \
  test_stdlib_testing_load__@vary__returns_expected_status_code

test_stdlib_testing_load__@vary__logs_error_message() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _testing.load "${args[@]}"

  _testing.error.mock.assert_called_once_with "${TEST_EXPECTED_ERROR_MESSAGE}"
}

@parametrize_with_invalid_args \
  test_stdlib_testing_load__@vary__logs_error_message

test_stdlib_testing_load__no_error______loads_module() {
  _capture.output _testing.load "__fixtures__/mock_load_target.sh"

  assert_output "    ${STDLIB_COLOUR_GREY}Loading module __fixtures__/mock_load_target.sh ...${STDLIB_COLOUR_NC}
Loaded!"
}

test_stdlib_testing_load__no_error______returns_status_code_0() {
  _capture.rc _testing.load "__fixtures__/mock_load_target.sh" > /dev/null

  assert_rc "0"
}

test_stdlib_testing_load__with_error____display_error_message() {
  _capture.output _testing.load "non-existent_target.sh"

  _testing.error.mock.assert_called_once_with "The module 'non-existent_target.sh' could not be found!"
}

test_stdlib_testing_load__with_error____returns_status_code_126() {
  _capture.rc _testing.load "non-existent_target.sh" > /dev/null

  assert_rc "126"
}
