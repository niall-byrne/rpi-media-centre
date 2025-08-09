#!/bin/bash

setup() {
  _mock.create stdlib.logger.warning
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION,TEST_EXPECTED_RC" \
    "no_args_________returns_status_code_127,,127" \
    "extra_arg_______returns_status_code_127,RED|substring|string to colourize|extra_arg,127" \
    "missing_colour__returns_status_code_126,|substring|string to colourize,126" \
    "empty_string____returns_status_code_126,RED|substring||,126",
}

# shellcheck disable=SC2034
test_stdlib_colour_substring_@vary() {
  local args=()
  _mock.create stdlib.logger.error

  IFS="|" read -ra args <<< "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.colour.substring "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_colour_substring_@vary

test_stdlib_colour_substring__valid_args_____red___________correct_output() {
  TEST_EXPECTED="test ${STDLIB_COLOUR_RED}string${STDLIB_COLOUR_NC} 1 string coloured"$'\n'
  TEST_INPUT="test string 1 string coloured"

  _capture.stdout_raw stdlib.string.colour.substring "RED" "string" "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_stdlib_colour_substring__valid_args_____green_________correct_output() {
  TEST_EXPECTED="test ${STDLIB_COLOUR_GREEN}string${STDLIB_COLOUR_NC} 1 string coloured"$'\n'
  TEST_INPUT="test string 1 string coloured"

  _capture.stdout_raw stdlib.string.colour.substring "GREEN" "string" "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_stdlib_colour_substring__valid_args_____non_existent__correct_output() {
  TEST_INPUT="test string 1 string coloured"

  _capture.stdout_raw stdlib.string.colour.substring "NON_EXISTENT" "string" "${TEST_INPUT}"

  stdlib.logger.warning.mock.assert_called_once_with \
    "The colour 'STDLIB_COLOUR_NON_EXISTENT' is not defined!"
}
