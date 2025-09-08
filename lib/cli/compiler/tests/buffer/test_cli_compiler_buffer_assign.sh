#!/bin/bash

@parametrize_with_assign_scenarios() {
  @parametrize \
    "${1}" \
    "TEST_BUFFER_CONTENT_RAW;TEST_EXPECTED_VALUE" \
    "single_line;line 1<br>;line 1" \
    "multiple_lines;line 1<br>line 2<br>;line 1<br>line 2" \
    "empty_buffer;;;"
}

# shellcheck disable=SC2034
test_cli_compiler_buffer_assign__@vary__assigns_buffer_content_to_variable() {
  local RPI_CLI_COMPILER_BUFFER="${TEST_BUFFER_CONTENT_RAW//<br>/$'\n'}"
  local my_variable
  local TEST_EXPECTED_VALUE="${TEST_EXPECTED_VALUE//<br>/$'\n'}"

  _cli_compiler_buffer_assign my_variable

  assert_equals "${TEST_EXPECTED_VALUE}" "${my_variable}"
}

@parametrize_with_assign_scenarios \
  test_cli_compiler_buffer_assign__@vary__assigns_buffer_content_to_variable
