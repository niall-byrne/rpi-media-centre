#!/bin/bash

setup() {
  _mock.create stdlib.logger.warning
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION,TEST_EXPECTED_RC" \
    "no_args_________returns_status_code_127,,127" \
    "extra_arg_______returns_status_code_127,RED|string to colourize|extra_arg,127" \
    "missing_colour__returns_status_code_126,|string to colourize,126" \
    "empty_string____returns_status_code___0,RED||,0"
}

# shellcheck disable=SC2034
test_stdlib_colour__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.colour "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_colour__@vary

test_stdlib_colour__valid_args______red______________________correct_output() {
  TEST_EXPECTED="${STDLIB_COLOUR_RED}test string${STDLIB_COLOUR_NC}"$'\n'
  TEST_INPUT="test string"

  _capture.stdout_raw stdlib.string.colour "RED" "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_stdlib_colour__empty_string____red______________________correct_output() {
  TEST_EXPECTED="${STDLIB_COLOUR_RED}${STDLIB_COLOUR_NC}"$'\n'
  TEST_INPUT=""

  _capture.stdout_raw stdlib.string.colour "RED" "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_stdlib_colour__valid_args______green____________________correct_output() {
  TEST_EXPECTED="${STDLIB_COLOUR_GREEN}test string${STDLIB_COLOUR_NC}"$'\n'
  TEST_INPUT="test string"

  _capture.stdout_raw stdlib.string.colour "GREEN" "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_stdlib_colour__empty_string____green____________________correct_output() {
  TEST_EXPECTED="${STDLIB_COLOUR_GREEN}${STDLIB_COLOUR_NC}"$'\n'
  TEST_INPUT=""

  _capture.stdout_raw stdlib.string.colour "GREEN" "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_stdlib_colour__valid_args______invalid_colour___________logs_warning() {
  TEST_INPUT="test string"

  _capture.stdout_raw stdlib.string.colour "NON_EXISTENT" "${TEST_INPUT}"

  stdlib.logger.warning.mock.assert_called_once_with \
    "The colour 'STDLIB_COLOUR_NON_EXISTENT' is not defined!"
}
