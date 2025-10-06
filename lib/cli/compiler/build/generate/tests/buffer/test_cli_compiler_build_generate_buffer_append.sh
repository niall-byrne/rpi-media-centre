#!/bin/bash

@parametrize_with_buffer_contents() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_BUFFER_CONTENT_RAW;TEST_FILE_LINE;TEST_EXPECTED_BUFFER" \
    "buffer_is_empty___;;file line1 content;file line1 content<br>" \
    "buffer_has_content;file line1 content<br>;file line2 content;file line1 content<br>file line2 content<br>"
}

# shellcheck disable=SC2034
test_cli_compiler_build_generate_buffer_append__@vary______appends_line_and_newline() {
  local RPI_CLI_COMPILER_BUFFER="${TEST_BUFFER_CONTENT_RAW//"<br>"/$'\n'}"
  local FILE_LINE="${TEST_FILE_LINE}"
  TEST_EXPECTED_BUFFER="${TEST_EXPECTED_BUFFER//"<br>"/$'\n'}"

  _cli_compiler_build_generate_buffer_append

  assert_equals "${TEST_EXPECTED_BUFFER}" "${RPI_CLI_COMPILER_BUFFER}"
}

@parametrize_with_buffer_contents \
  test_cli_compiler_build_generate_buffer_append__@vary______appends_line_and_newline
