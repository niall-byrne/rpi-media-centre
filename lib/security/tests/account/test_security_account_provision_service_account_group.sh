#!/bin/bash

TEST_GROUPNAME="test_group"

setup() {
  _fixture_mock_logs
  _mock.create getent
  _mock.create stdlib.io.stdin.confirmation
  _mock.create groupadd
  _mock.create _security_defaults_set_gid
}

@parametrize_vary_gid_set() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "RPI_SVC_GID;TEST_GROUPNAME_ADD_ARGS" \
    "gid_not_set;;-r ${TEST_GROUPNAME};" \
    "gid_set____;1001;-g 1001 -r ${TEST_GROUPNAME};"
}

test_security_account_provision_service_account_group__calls_getent() {
  _security_account_provision_service_account_group "${TEST_GROUPNAME}"

  assert_equals "1" "$(getent.mock.get.count)"
  assert_equals "group ${TEST_GROUPNAME}" "$(getent.mock.get.call "1")"
}

test_security_account_provision_service_account_group__group_exists__________does_not_call_groupadd() {
  getent.mock.set.rc 0

  _security_account_provision_service_account_group "${TEST_GROUPNAME}"

  assert_equals "0" "$(groupadd.mock.get.count)"
}

test_security_account_provision_service_account_group__group_exists__________logs_notice() {
  getent.mock.set.rc 0

  _security_account_provision_service_account_group "${TEST_GROUPNAME}"

  assert_equals "1" "$(_cli_log_notice.mock.get.count)"
  assert_equals \
    "SECURITY: The group '${TEST_GROUPNAME}' already exists, nothing to do." \
    "$(_cli_log_notice.mock.get.call "1")"
}

test_security_account_provision_service_account_group__group_exists__________sets_gid() {
  getent.mock.set.rc 0

  _security_account_provision_service_account_group "${TEST_GROUPNAME}"

  assert_equals "1" "$(_security_defaults_set_gid.mock.get.count)"
  assert_equals "" "$(_security_defaults_set_gid.mock.get.call "1")"
}

test_security_account_provision_service_account_group__group_does_not_exist__@vary__calls_stdlib_io_stdin_confirmation() {
  getent.mock.set.rc 1

  _security_account_provision_service_account_group "${TEST_GROUPNAME}"

  assert_equals "1" "$(stdlib.io.stdin.confirmation.mock.get.count)"
  assert_equals "" "$(stdlib.io.stdin.confirmation.mock.get.call "1")"
}

@parametrize_vary_gid_set \
  test_security_account_provision_service_account_group__group_does_not_exist__@vary__calls_stdlib_io_stdin_confirmation

test_security_account_provision_service_account_group__group_does_not_exist__@vary__calls_groupadd() {
  getent.mock.set.rc 1

  _security_account_provision_service_account_group "${TEST_GROUPNAME}"

  assert_equals "1" "$(groupadd.mock.get.count)"
  assert_equals "${TEST_GROUPNAME_ADD_ARGS}" "$(groupadd.mock.get.call "1")"
}

@parametrize_vary_gid_set \
  test_security_account_provision_service_account_group__group_does_not_exist__@vary__calls_groupadd

test_security_account_provision_service_account_group__group_does_not_exist__@vary__calls_security_defaults_set_gid() {
  getent.mock.set.rc 1

  _security_account_provision_service_account_group "${TEST_GROUPNAME}"

  assert_equals "1" "$(_security_defaults_set_gid.mock.get.count)"
  assert_equals "" "$(_security_defaults_set_gid.mock.get.call "1")"
}

@parametrize_vary_gid_set \
  test_security_account_provision_service_account_group__group_does_not_exist__@vary__calls_security_defaults_set_gid

test_security_account_provision_service_account_group__group_does_not_exist__@vary__logs_successs() {
  getent.mock.set.rc 1
  _security_defaults_set_gid.mock.set.subcommand 'RPI_SVC_GID="99"'

  _security_account_provision_service_account_group "${TEST_GROUPNAME}"

  assert_equals "1" "$(_cli_log_success.mock.get.count)"
  assert_equals \
    "SECURITY: The service account group '${TEST_GROUPNAME}' has been created with gid '99' !" \
    "$(_cli_log_success.mock.get.call "1")"
}

@parametrize_vary_gid_set \
  test_security_account_provision_service_account_group__group_does_not_exist__@vary__logs_successs
