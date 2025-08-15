#!/bin/bash

test_stdlib_testing_error__no_args________generates_no_stderr() {
  _capture.stderr _testing.error

  assert_null "${TEST_OUTPUT}"
}

test_stdlib_testing_error__single_arg_____generates_stderr() {
  _capture.stderr _testing.error "error message1"

  assert_output "${STDLIB_COLOUR_LIGHT_RED}error message1${STDLIB_COLOUR_NC}"
}

test_stdlib_testing_error__multiple_args__generates_stderr() {
  _capture.output _testing.error "error message1" "error message2"

  assert_output "${STDLIB_COLOUR_LIGHT_RED}error message1${STDLIB_COLOUR_NC}
${STDLIB_COLOUR_LIGHT_RED}error message2${STDLIB_COLOUR_NC}"
}
