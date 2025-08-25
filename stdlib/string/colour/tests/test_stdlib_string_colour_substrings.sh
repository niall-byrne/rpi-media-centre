#!/bin/bash

setup() {
  _mock.create stdlib.logger.warning
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_________returns_status_code_127;;127" \
    "extra_arg_______returns_status_code_127;RED|substring|string to colourize|extra_arg;127" \
    "missing_colour__returns_status_code_126;|substring|string to colourize;126" \
    "empty_string____returns_status_code___0;RED|substring||;0"
}

# shellcheck disable=SC2034
test_stdlib_colour_substrings__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.colour.substrings "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_colour_substrings__@vary

test_stdlib_colour_substrings__valid_args______red______________________correct_output() {
  TEST_EXPECTED="test ${STDLIB_COLOUR_RED}string${STDLIB_COLOUR_NC} 2 ${STDLIB_COLOUR_RED}string${STDLIB_COLOUR_NC}s coloured"$'\n'
  TEST_INPUT="test string 2 strings coloured"

  _capture.stdout_raw stdlib.string.colour.substrings "RED" "string" "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_stdlib_colour_substrings__empty_string____red______________________correct_output() {
  TEST_INPUT=""

  _capture.stdout stdlib.string.colour.substrings "RED" "string" "${TEST_INPUT}"

  assert_output_null
}

test_stdlib_colour_substrings__valid_args______green____________________correct_output() {
  TEST_EXPECTED="test ${STDLIB_COLOUR_GREEN}string${STDLIB_COLOUR_NC} 2 ${STDLIB_COLOUR_GREEN}string${STDLIB_COLOUR_NC}s coloured"$'\n'
  TEST_INPUT="test string 2 strings coloured"

  _capture.stdout_raw stdlib.string.colour.substrings "GREEN" "string" "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_stdlib_colour_substrings__empty_string____green____________________correct_output() {
  TEST_INPUT=""

  _capture.stdout stdlib.string.colour.substrings "GREEN" "string" "${TEST_INPUT}"

  assert_output_null
}

test_stdlib_colour_substrings__valid_args______non_existent_____________correct_output() {
  TEST_INPUT="test string 2 strings coloured"

  _capture.stdout_raw stdlib.string.colour.substrings "NON_EXISTENT" "string" "${TEST_INPUT}"

  stdlib.logger.warning.mock.assert_called_once_with \
    "1($(stdlib.message.get COLOUR_NOT_DEFINED NON_EXISTENT))"
}
