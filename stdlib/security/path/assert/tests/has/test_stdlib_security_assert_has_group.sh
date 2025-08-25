#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
  _mock.create stdlib.logger.info
}

@parametrize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args____________127;;127" \
    "extra_arg__________127;/etc|group1|extra_arg;127" \
    "null_path__________126;|group1;126" \
    "null_group_________126;/etc||;126" \
    "non_existent_path__126;non-existent|group1;126"
}

# shellcheck disable=SC2034
test_stdlib_security_path_assert_has_group__@vary___________returns_expected_status_code() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.security.path.assert.has_group "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_security_path_assert_has_group__@vary___________returns_expected_status_code

# shellcheck disable=SC2034
test_stdlib_security_path_assert_has_group__@vary___________logs_expected_message() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  stdlib.security.path.assert.has_group "${args[@]}" > /dev/null

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.message.get ARGUMENTS_INVALID))"
}

@parametrize_with_arg_combos \
  test_stdlib_security_path_assert_has_group__@vary___________logs_expected_message

test_stdlib_security_path_assert_has_group__valid_args_________non_matching__logs_an_error() {
  stdlib.security.path.assert.has_group "/etc" "group1" 2> /dev/null

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.message.get SECURITY_INSECURE_GROUP_OWNERSHIP "/etc"))"
  stdlib.logger.info.mock.assert_called_once_with \
    "1($(stdlib.message.get SECURITY_SUGGEST_CHGRP "group1" "/etc"))"
}

test_stdlib_security_path_assert_has_group__valid_args_________non_matching__returns_status_code_1() {
  _capture.rc stdlib.security.path.assert.has_group "/etc" "group1" 2> /dev/null

  assert_rc "1"
}

test_stdlib_security_path_assert_has_group__valid_args_________matching______returns_status_code_0() {
  _capture.rc stdlib.security.path.assert.has_group "/etc" "root"

  assert_rc "0"
}
