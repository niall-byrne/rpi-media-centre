#!/bin/bash

setup() {
  _mock.create getent
}

@parameterize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_____returns_status_code_127;;127" \
    "null_group__returns_status_code_126;|;126" \
    "extra_arg___returns_status_code_127;group1|extra_arg;127"
}

@parametrize_with_getent_output() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "GETENT_STDOUT;EXPECTED_GID" \
    "gid_501_;mock_groupname:x:501:;501" \
    "gid_1001;mock_groupname:x:1001:;1001"
}

test_security_get_gid__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.security.get.gid "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parameterize_with_arg_combos \
  test_security_get_gid__@vary

test_security_get_gid__valid_args__calls_getent() {
  stdlib.security.get.gid "mock_groupname"

  getent.mock.assert_called_once_with "1(group) 2(mock_groupname)"
}

test_security_get_gid__valid_args__group_found______@vary__emits_parsed_getent_output() {
  getent.mock.set.stdout "${GETENT_STDOUT}"

  _capture.output stdlib.security.get.gid "mock_groupname"

  assert_equals "${EXPECTED_GID}" "${TEST_OUTPUT}"
}

@parametrize_with_getent_output \
  test_security_get_gid__valid_args__group_found______@vary__emits_parsed_getent_output

test_security_get_gid__valid_args__group_found______@vary__returns_status_code_0() {
  getent.mock.set.stdout "${GETENT_STDOUT}"

  _capture.rc stdlib.security.get.gid "mock_groupname" > /dev/null

  assert_rc "0"
}

@parametrize_with_getent_output \
  test_security_get_gid__valid_args__group_found______@vary__returns_status_code_0

test_security_get_gid__valid_args__group_not_found__returns_status_code_126() {
  getent.mock.set.rc 1

  _capture.rc stdlib.security.get.gid "mock_groupname"

  assert_rc "126"
}
