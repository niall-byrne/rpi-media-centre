#!/bin/bash

@parametrize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "null_padding_____returns_status_code_126;|80|input_string;126" \
    "invalid_padding__returns_status_code_126;aa|80|input_string;126" \
    "null_limit_______returns_status_code_126;20||input_string;126" \
    "invalid_limit____returns_status_code_126;20|aa|input_string;126" \
    "extra_arg________returns_status_code_127;20|80|input_string|extra_arg;127" \
    "null_input_______returns_status_code___0;20|80||;0" \
    "valid_args_______returns_status_code___0;20|80|input_string;0"
}

@parametrize_with_wrap_content() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED;TEST_LINE_BREAK_CHAR;TEST_PREFIX_STRING" \
    "short_string____pad_width_10__wrap_20__auto_wrap____no_indent____;10|20|don't wrap;don't wrap;;;" \
    "wrapped_string__pad_width_10__wrap_20__auto_wrap____no_indent____;10|20|this is a string of text that i would like to wrap;this is a<br>          string of<br>          text that<br>          i would<br>          like to<br>          wrap;;;" \
    "wrapped_string__pad_width_05__wrap_20__auto_wrap____no_indent____;5|20|this is a string of text that i would like to wrap;this is a<br>     string of text<br>     that i would<br>     like to wrap;;;" \
    "wrapped_string__pad_width_10__wrap_20__forced_wrap__no_indent____;10|20|this is a string of text *that i would like to wrap;this is a<br>          string of<br>          text<br>          that i<br>          would like<br>          to wrap;;;" \
    "wrapped_string__pad_width_10__wrap_20__custom_wrap__no_indent____;10|20|this is a string of text !that i would like to wrap;this is a<br>          string of<br>          text<br>          that i<br>          would like<br>          to wrap;!;;" \
    "wrapped_string__pad_width_10__wrap_30__auto_wrap____custom_indent;10|30|this is a string of text that i would like to wrap;this is a string<br>          ***of text that i<br>          ***would like to<br>          ***wrap;;***" \
    "wrapped_string__pad_width_10__wrap_30__forced_wrap__custom_indent;10|30|this is a string of text *that i would like to wrap;this is a string<br>          ***of text<br>          ***that i would like<br>          ***to wrap;;***" \
    "wrapped_string__pad_width_10__wrap_30__custom_wrap__custom_indent;10|30|this is a string of text !that i would like to wrap;this is a string<br>          ***of text<br>          ***that i would like<br>          ***to wrap;!;***"
}

# shellcheck disable=SC2034
test_stdlib_string_wrap__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.wrap "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_wrap__@vary

# shellcheck disable=SC2034
test_stdlib_string_wrap__valid_args_______arg___@vary__correct_output() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  TEST_EXPECTED="${TEST_EXPECTED//'<br>'/$'\n'}"

  _STDLIB_LINE_BREAK_CHAR="${TEST_LINE_BREAK_CHAR}" \
    _STDLIB_WRAP_PREFIX_STRING="${TEST_PREFIX_STRING}" \
    _capture.output stdlib.string.wrap "${args[@]}"

  assert_output "${TEST_EXPECTED}"
}

@parametrize_with_wrap_content \
  test_stdlib_string_wrap__valid_args_______arg___@vary__correct_output

test_stdlib_string_wrap__null_input_______arg___wrapped_string__pad_width_10__wrap_20__auto_wrap____no_indent______correct_output() {
  TEST_INPUT=""

  _capture.output stdlib.string.wrap "10" "20" "${TEST_INPUT}"

  assert_output_null
}
