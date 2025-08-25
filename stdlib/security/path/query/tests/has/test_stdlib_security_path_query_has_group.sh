#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
  _mock.create stdlib.security.get.gid
  _mock.create stat
}

@parametrize_with_required_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args______________returns_status_code_127;;127" \
    "extra_arg____________returns_status_code_127;/etc|group1|extra_arg;127" \
    "null_path____________returns_status_code_126;|group1;126" \
    "null_group___________returns_status_code_126;/etc||;126" \
    "non_existent_path____returns_status_code_126;non-existent|group1;126"
}

test_stdlib_security_path_query_has_group__invalid_args__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.security.path.query.has_group "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_required_arg_combos \
  test_stdlib_security_path_query_has_group__invalid_args__@vary

test_stdlib_security_path_query_has_group__valid_args____calls_get_gid_as_expected() {
  stdlib.security.path.query.has_group "/etc" "group1"

  stdlib.security.get.gid.mock.assert_called_once_with "1(group1)"
}

test_stdlib_security_path_query_has_group__valid_args____calls_stat_as_expected() {
  stdlib.security.path.query.has_group "/etc" "group1"

  stat.mock.assert_called_once_with "1(-c) 2(%g) 3(/etc)"
}

test_stdlib_security_path_query_has_group__valid_args____non_matching_group___returns_status_code_1() {
  stdlib.security.get.gid.mock.set.stdout 501
  stat.mock.set.stdout 1000

  _capture.rc stdlib.security.path.query.has_group "/etc" "group1"

  assert_rc "1"
}

test_stdlib_security_path_query_has_group__valid_args____matching_group_______returns_status_code_0() {
  stdlib.security.get.gid.mock.set.stdout 501
  stat.mock.set.stdout 501

  _capture.rc stdlib.security.path.query.has_group "/etc" "group1"

  assert_rc "0"
}
