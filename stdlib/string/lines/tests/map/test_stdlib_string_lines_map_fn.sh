#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/string/lines/tests/map/__fixtures__/map_fn.sh"

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_args_and_status_codes() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_______________returns_status_code_127;;127" \
    "extra_arg_____________returns_status_code_127;_uppercase|input string|extra_arg;127" \
    "null_fn_______________returns_status_code_126;|input string;126" \
    "invalid_fn_and_input__returns_status_code_126;_invalid_fn_name|input string;126" \
    "null_input____________returns_status_code___0;_uppercase||;0" \
    "valid_fn_and_input____returns_status_code___0;_uppercase|input string;0"
}

test_stdlib_string_lines_map_fn__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.lines.map.fn "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_args_and_status_codes \
  test_stdlib_string_lines_map_fn__@vary

test_stdlib_string_lines_map_fn__valid_args____________default_delimiter__single_line__applies_fn() {
  _capture.output_raw stdlib.string.lines.map.fn _uppercase "new line"

  assert_output "UPPERCASE: NEW LINE"$'\n'
}

test_stdlib_string_lines_map_fn__null_input____________default_delimiter__single_line__applies_fn() {
  _capture.output_raw stdlib.string.lines.map.fn _uppercase ""

  assert_output "UPPERCASE: "$'\n'
}

test_stdlib_string_lines_map_fn__valid_args____________default_delimiter__multi_line___applies_fn() {
  _capture.output_raw stdlib.string.lines.map.fn _uppercase "new line"$'\n'"delimited"$'\n'"line"

  assert_output "UPPERCASE: NEW LINE"$'\n'"UPPERCASE: DELIMITED"$'\n'"UPPERCASE: LINE"$'\n'
}

test_stdlib_string_lines_map_fn__valid_args____________custom__delimiter__single_line__applies_fn() {
  _STDLIB_DELIMITER="|" _capture.output_raw stdlib.string.lines.map.fn _uppercase "new line"

  assert_output "UPPERCASE: NEW LINE"$'\n'
}

test_stdlib_string_lines_map_fn__valid_args____________custom__delimiter__multi_line___applies_fn() {
  _STDLIB_DELIMITER="|" _capture.output_raw stdlib.string.lines.map.fn _uppercase "pipe|delimited|line"

  assert_output "UPPERCASE: PIPE|UPPERCASE: DELIMITED|UPPERCASE: LINE"$'\n'
}
