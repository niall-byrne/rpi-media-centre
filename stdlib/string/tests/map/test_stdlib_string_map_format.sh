#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_args_and_status_codes() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args__________________returns_status_code_127;;127" \
    "extra_arg________________returns_status_code_127;%s|input _string|extra_arg;127" \
    "null_format_string_______returns_status_code_126;|input string;126" \
    "format_string_and_input__returns_status_code___0;%s|input string;0" \
    "null_input_______________returns_status_code___0;%s||;0"
}

test_stdlib_string_map_format__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.map.format "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_args_and_status_codes \
  test_stdlib_string_map_format__@vary

test_stdlib_string_map_format__valid_args_______________default_delimiter__single_line__applies_printf() {
  _capture.output_raw stdlib.string.map.format "# %s" "new line"

  assert_output "# new line"$'\n'
}

test_stdlib_string_map_format__null_args_______________default_delimiter__single_line__applies_printf() {
  _capture.output_raw stdlib.string.map.format "# %s" ""

  assert_output "# "$'\n'
}

test_stdlib_string_map_format__valid_args_______________default_delimiter__multi_line___applies_printf() {
  _capture.output_raw stdlib.string.map.format "# %s" "new line"$'\n'"delimited"$'\n'"line"

  assert_output "# new line"$'\n'"# delimited"$'\n'"# line"$'\n'
}

test_stdlib_string_map_format__valid_args_______________custom__delimiter__single_line__applies_printf() {
  _DELIMITER="|" _capture.output_raw stdlib.string.map.format "# %s" "new line"

  assert_output "# new line"$'\n'
}

test_stdlib_string_map_format__valid_args_______________custom__delimiter__multi_line___applies_printf() {
  _DELIMITER="|" _capture.output_raw stdlib.string.map.format "# %s" "pipe|delimited|line"

  assert_output "# pipe|# delimited|# line"$'\n'
}
