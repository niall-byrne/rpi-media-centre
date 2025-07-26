#!/bin/bash

#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION,TEST_EXPECTED_RC" \
    "no_args____________returns_status_code_127,,127" \
    "extra_arg__________returns_status_code_127,1|extra_arg,127" \
    "empty_string_______returns_status_code_126,|,126" \
    "alphanumeric_______returns_status_code___1,aa011,1" \
    "non_boolean_digit__returns_status_code___1,3,1" \
    "boolean_off________returns_status_code___0,0,0" \
    "boolean_on_________returns_status_code___0,1,0"
}

@parametrize_with_error_messages() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION,TEST_EXPECTED_LOG_MESSAGE" \
    "no_args__________,,Invalid arguments provided!," \
    "extra_arg________,1|extra_arg,Invalid arguments provided!," \
    "empty_string_____,|,The value '' is not a set string containing a boolean (0 or 1)!" \
    "alphanumeric_____,aa011,The value 'aa011' is not a set string containing a boolean (0 or 1)!" \
    "non_boolean_digit,3,The value '3' is not a set string containing a boolean (0 or 1)!"
}

# shellcheck disable=SC2034
test_stdlib_string_assert_is_boolean__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  IFS="|" read -ra args <<< "${TEST_ARGS_DEFINITION}"

  _capture_rc stdlib.string.assert.is_boolean "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_assert_is_boolean__@vary

test_stdlib_string_assert_is_boolean__@vary__logs_an_error() {
  local args=()
  local expected_log_messages=()

  IFS="|" read -ra args <<< "${TEST_ARGS_DEFINITION}"
  IFS="|" read -ra expected_log_messages <<< "${TEST_EXPECTED_LOG_MESSAGE}"

  _capture_rc stdlib.string.assert.is_boolean "${args[@]}" > /dev/null

  stdlib.logger.error.mock.assert_calls_are \
    "${expected_log_messages[@]}"
}

@parametrize_with_error_messages \
  test_stdlib_string_assert_is_boolean__@vary__logs_an_error
