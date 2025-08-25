#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
  _mock.create stdlib.security.get.uid
  _mock.create stat
}

@parametrize_with_required_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args____________returns_status_code_127;;127" \
    "extra_arg__________returns_status_code_127;/etc|user1|extra_arg;127" \
    "null_path__________returns_status_code_126;|user1;126" \
    "null_user__________returns_status_code_126;/etc||;126" \
    "non_existent_path__returns_status_code_126;non-existent|user1;126"
}

test_stdlib_security_path_query_has_owner__invalid_args__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.security.path.query.has_owner "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_required_arg_combos \
  test_stdlib_security_path_query_has_owner__invalid_args__@vary

test_stdlib_security_path_query_has_owner__valid_args____calls_get_uid_as_expected() {
  stdlib.security.path.query.has_owner "/etc" "user1"

  stdlib.security.get.uid.mock.assert_called_once_with "1(user1)"
}

test_stdlib_security_path_query_has_owner__valid_args____calls_stat_as_expected() {
  stdlib.security.path.query.has_owner "/etc" "user1"

  stat.mock.assert_called_once_with "1(-c) 2(%u) 3(/etc)"
}

test_stdlib_security_path_query_has_owner__valid_args____non_matching_user__returns_status_code_1() {
  stdlib.security.get.uid.mock.set.stdout 501
  stat.mock.set.stdout 1000

  _capture.rc stdlib.security.path.query.has_owner "/etc" "user1"

  assert_rc "1"
}

test_stdlib_security_path_query_has_owner__valid_args____matching_user______returns_status_code_0() {
  stdlib.security.get.uid.mock.set.stdout 501
  stat.mock.set.stdout 501

  _capture.rc stdlib.security.path.query.has_owner "/etc" "user1"

  assert_rc "0"
}
