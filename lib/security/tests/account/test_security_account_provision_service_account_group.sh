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
    "RPI_SVC_GID;TEST_GROUPADD_ARGS" \
    "gid_not_set;;-r ${TEST_GROUPNAME};" \
    "gid_set____;1001;-g 1001 -r ${TEST_GROUPNAME};"
}

test_security_account_provision_service_account_group__calls_getent() {
  _security_account_provision_service_account_group "${TEST_GROUPNAME}"

  getent.mock.assert_called_once_with "1(group) 2(${TEST_GROUPNAME})"
}

test_security_account_provision_service_account_group__group_exists__________does_not_call_groupadd() {
  getent.mock.set.rc 0

  _security_account_provision_service_account_group "${TEST_GROUPNAME}"

  groupadd.mock.assert_not_called
}

test_security_account_provision_service_account_group__group_exists__________logs_notice() {
  getent.mock.set.rc 0

  _security_account_provision_service_account_group "${TEST_GROUPNAME}"

  _cli_log_notice.mock.assert_called_once_with \
    "1(SECURITY: The group '${TEST_GROUPNAME}' already exists, nothing to do.)"
}

test_security_account_provision_service_account_group__group_exists__________sets_gid() {
  getent.mock.set.rc 0

  _security_account_provision_service_account_group "${TEST_GROUPNAME}"

  _security_defaults_set_gid.mock.assert_called_once_with ""
}

test_security_account_provision_service_account_group__group_does_not_exist__@vary__calls_stdlib_io_stdin_confirmation() {
  getent.mock.set.rc 1

  _security_account_provision_service_account_group "${TEST_GROUPNAME}"

  stdlib.io.stdin.confirmation.mock.assert_called_once_with ""
}

@parametrize_vary_gid_set \
  test_security_account_provision_service_account_group__group_does_not_exist__@vary__calls_stdlib_io_stdin_confirmation

test_security_account_provision_service_account_group__group_does_not_exist__@vary__calls_groupadd() {
  getent.mock.set.rc 1

  _security_account_provision_service_account_group "${TEST_GROUPNAME}"

  groupadd.mock.assert_called_once_with "$(_mock.arg_string.from_string "${TEST_GROUPADD_ARGS}")"
}

@parametrize_vary_gid_set \
  test_security_account_provision_service_account_group__group_does_not_exist__@vary__calls_groupadd

test_security_account_provision_service_account_group__group_does_not_exist__@vary__calls_security_defaults_set_gid() {
  getent.mock.set.rc 1

  _security_account_provision_service_account_group "${TEST_GROUPNAME}"

  _security_defaults_set_gid.mock.assert_called_once_with ""
}

@parametrize_vary_gid_set \
  test_security_account_provision_service_account_group__group_does_not_exist__@vary__calls_security_defaults_set_gid

test_security_account_provision_service_account_group__group_does_not_exist__@vary__logs_successs() {
  getent.mock.set.rc 1
  _security_defaults_set_gid.mock.set.subcommand 'RPI_SVC_GID="99"'

  _security_account_provision_service_account_group "${TEST_GROUPNAME}"

  _cli_log_success.mock.assert_called_once_with \
    "1(SECURITY: The service account group '${TEST_GROUPNAME}' has been created with gid '99' !)"
}

@parametrize_vary_gid_set \
  test_security_account_provision_service_account_group__group_does_not_exist__@vary__logs_successs
