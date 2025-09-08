#!/bin/bash

@parametrize_with_buffer_contents() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_BUFFER_CONTENT_RAW" \
    "buffer_is_empty___;;" \
    "buffer_has_content;file line1 content<br>file line2 content<br>"
}

test_cli_compiler_buffer_clear__@vary__clears_the_buffer() {
  local RPI_CLI_COMPILER_BUFFER="${TEST_BUFFER_CONTENT_RAW//<br>/$'\n'}"

  _cli_compiler_buffer_clear

  assert_null "${RPI_CLI_COMPILER_BUFFER}"
}

@parametrize_with_buffer_contents \
  test_cli_compiler_buffer_clear__@vary__clears_the_buffer
