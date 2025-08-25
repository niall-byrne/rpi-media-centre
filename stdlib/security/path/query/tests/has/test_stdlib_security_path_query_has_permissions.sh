#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
  _mock.create stat
}

@parametrize_with_required_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_____________returns_status_code_127;;127" \
    "extra_arg___________returns_status_code_127;/etc|644|extra_arg;127" \
    "null_path___________returns_status_code_126;|644;126" \
    "null_perms__________returns_status_code_126;/etc||;126" \
    "invalid_perms_______returns_status_code_126;/etc|aaa;126" \
    "non_existent_path___returns_status_code_126;non-existent|644;126"
}

test_stdlib_security_path_query_has_permissions__invalid_args__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.security.path.query.has_permissions "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_required_arg_combos \
  test_stdlib_security_path_query_has_permissions__invalid_args__@vary

test_stdlib_security_path_query_has_permissions__valid_args____calls_stat_as_expected() {
  stdlib.security.path.query.has_permissions "/etc" "644"

  stat.mock.assert_called_once_with "1(-c) 2(%a) 3(/etc)"
}

test_stdlib_security_path_query_has_permissions__valid_args____non_matching_perms__returns_status_code_1() {
  stat.mock.set.stdout 755

  _capture.rc stdlib.security.path.query.has_permissions "/etc" "644"

  assert_rc "1"
}

test_stdlib_security_path_query_has_permissions__valid_args____matching_perms______returns_status_code_0() {
  stat.mock.set.stdout 644

  _capture.rc stdlib.security.path.query.has_permissions "/etc" "644"

  assert_rc "0"
}
