#!/bin/bash

#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION,TEST_EXPECTED_RC" \
    "no_args_____________returns_status_code_127,,127" \
    "extra_arg___________returns_status_code_127,aa011|extra_arg,127" \
    "empty_string________returns_status_code___1,|,1" \
    "single_char_string__returns_status_code___0,a,0" \
    "multi_char_string___returns_status_code___0,aa011,0"
}

@parametrize_with_error_messages() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION,TEST_EXPECTED_LOG_MESSAGE" \
    "no_args___________,,Invalid arguments provided!," \
    "extra_arg_________,aa011|extra_arg,Invalid arguments provided!" \
    "empty_string______,|,The value '' is not a set string!"
}

# shellcheck disable=SC2034
test_stdlib_string_assert_is_string__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  IFS="|" read -ra args <<< "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.assert.is_string "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_assert_is_string__@vary

test_stdlib_string_assert_is_string__@vary__logs_an_error() {
  local args=()
  local expected_log_messages=()

  IFS="|" read -ra args <<< "${TEST_ARGS_DEFINITION}"
  IFS="|" read -ra expected_log_messages <<< "${TEST_EXPECTED_LOG_MESSAGE}"

  _capture.rc stdlib.string.assert.is_string "${args[@]}" > /dev/null

  stdlib.logger.error.mock.assert_calls_are \
    "${expected_log_messages[@]}"
}

@parametrize_with_error_messages \
  test_stdlib_string_assert_is_string__@vary__logs_an_error
