#!/bin/bash

setup() {
  _mock.create id
}

@parameterize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_____returns_status_code_127;;127" \
    "null_user___returns_status_code_126;|;126" \
    "extra_arg___returns_status_code_127;user1|extra_arg;127"
}

@parametrize_with_id_output() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "ID_STDOUT" \
    "uid_501_;501" \
    "uid_1001;1001"
}

test_security_get_uid__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.security.get.uid "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parameterize_with_arg_combos \
  test_security_get_uid__@vary

test_security_get_uid__valid_args__calls_id() {
  stdlib.security.get.uid "mock_username"

  id.mock.assert_called_once_with "1(-u) 2(mock_username)"
}

test_security_get_uid__valid_args__id_found______@vary__emits_id_output() {
  id.mock.set.stdout "${ID_STDOUT}"

  _capture.output stdlib.security.get.uid "mock_username"

  assert_equals "${ID_STDOUT}" "${TEST_OUTPUT}"
}

@parametrize_with_id_output \
  test_security_get_uid__valid_args__id_found______@vary__emits_id_output

test_security_get_uid__valid_args__id_found______@vary__returns_status_code_0() {
  id.mock.set.stdout "${ID_STDOUT}"

  _capture.rc stdlib.security.get.uid "mock_username" > /dev/null

  assert_rc "0"
}

@parametrize_with_id_output \
  test_security_get_uid__valid_args__id_found______@vary__returns_status_code_0

test_security_get_uid__valid_args__id_not_found__returns_status_code_126() {
  id.mock.set.rc 1

  _capture.rc stdlib.security.get.uid "mock_username" > /dev/null

  assert_rc "126"
}
