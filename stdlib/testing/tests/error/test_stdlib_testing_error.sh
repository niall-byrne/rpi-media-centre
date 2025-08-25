#!/bin/bash

# shellcheck disable=SC2034
setup_suite() {
  expected_colour="$(stdlib.setting.theme.get_colour "${STDLIB_TESTING_THEME_ERROR}")"
}

test_stdlib_testing_error__no_args________generates_no_stderr() {
  _capture.stderr _testing.error

  assert_output_null
}

test_stdlib_testing_error__single_arg_____generates_stderr() {
  _capture.stderr _testing.error "error message1"

  assert_output "${!expected_colour}error message1${STDLIB_COLOUR_NC}"
}

test_stdlib_testing_error__multiple_args__generates_stderr() {
  _capture.output _testing.error "error message1" "error message2"

  assert_output "${!expected_colour}error message1${STDLIB_COLOUR_NC}
${!expected_colour}error message2${STDLIB_COLOUR_NC}"
}
