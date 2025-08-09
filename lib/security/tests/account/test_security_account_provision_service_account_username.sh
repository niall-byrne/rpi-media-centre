#!/bin/bash

TEST_USERNAME="test_user"
RPI_SVC_GID="99"

setup() {
  _fixture_mock_logs
  _mock.create getent
  _mock.create _io_prompt_confirmation
  _mock.create useradd
  _mock.create _security_defaults_set_uid
}

@parametrize_vary_uid_set() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "RPI_SVC_UID,TEST_USERADD_ARGS" \
    "uid_not_set,,-g ${RPI_SVC_GID} -r -s /usr/sbin/nologin ${TEST_USERNAME}," \
    "uid_set____,1001,-u 1001 -g ${RPI_SVC_GID} -r -s /usr/sbin/nologin -o ${TEST_USERNAME},"
}

test_security_account_provision_service_account_username__calls_getent() {
  _security_account_provision_service_account_username "${TEST_USERNAME}"

  assert_equals "1" "$(getent.mock.get.count)"
  assert_equals "passwd ${TEST_USERNAME}" "$(getent.mock.get.call "1")"
}

test_security_account_provision_service_account_username__user_exists__________does_not_call_useradd() {
  getent.mock.set.rc 0

  _security_account_provision_service_account_username "${TEST_USERNAME}"

  assert_equals "0" "$(useradd.mock.get.count)"
}

test_security_account_provision_service_account_username__user_exists__________logs_notice() {
  getent.mock.set.rc 0

  _security_account_provision_service_account_username "${TEST_USERNAME}"

  assert_equals "1" "$(_cli_log_notice.mock.get.count)"
  assert_equals \
    "SECURITY: The user '${TEST_USERNAME}' already exists, nothing to do." \
    "$(_cli_log_notice.mock.get.call "1")"
}

test_security_account_provision_service_account_username__user_exists__________sets_uid() {
  getent.mock.set.rc 0

  _security_account_provision_service_account_username "${TEST_USERNAME}"

  assert_equals "1" "$(_security_defaults_set_uid.mock.get.count)"
  assert_equals "" "$(_security_defaults_set_uid.mock.get.call "1")"
}

test_security_account_provision_service_account_username__user_does_not_exist__@vary__calls_io_prompt_confirmation() {
  getent.mock.set.rc 1

  _security_account_provision_service_account_username "${TEST_USERNAME}"

  assert_equals "1" "$(_io_prompt_confirmation.mock.get.count)"
  assert_equals "" "$(_io_prompt_confirmation.mock.get.call "1")"
}

@parametrize_vary_uid_set \
  test_security_account_provision_service_account_username__user_does_not_exist__@vary__calls_io_prompt_confirmation

test_security_account_provision_service_account_username__user_does_not_exist__@vary__calls_useradd() {
  getent.mock.set.rc 1

  _security_account_provision_service_account_username "${TEST_USERNAME}"

  assert_equals "1" "$(useradd.mock.get.count)"
  assert_equals "${TEST_USERADD_ARGS}" "$(useradd.mock.get.call "1")"
}

@parametrize_vary_uid_set \
  test_security_account_provision_service_account_username__user_does_not_exist__@vary__calls_useradd

test_security_account_provision_service_account_username__user_does_not_exist__@vary__calls_security_defaults_set_gid() {
  getent.mock.set.rc 1

  _security_account_provision_service_account_username "${TEST_USERNAME}"

  assert_equals "1" "$(_security_defaults_set_uid.mock.get.count)"
  assert_equals "" "$(_security_defaults_set_uid.mock.get.call "1")"
}

@parametrize_vary_uid_set \
  test_security_account_provision_service_account_username__user_does_not_exist__@vary__calls_security_defaults_set_gid

test_security_account_provision_service_account_username__user_does_not_exist__@vary__logs_successs() {
  getent.mock.set.rc 1
  _security_defaults_set_uid.mock.set.subcommand 'RPI_SVC_UID="99"'

  _security_account_provision_service_account_username "${TEST_USERNAME}"

  assert_equals "1" "$(_cli_log_success.mock.get.count)"
  assert_equals \
    "SECURITY: The service account user '${TEST_USERNAME}' has been created with uid '99' !" \
    "$(_cli_log_success.mock.get.call "1")"
}

@parametrize_vary_uid_set \
  test_security_account_provision_service_account_username__user_does_not_exist__@vary__logs_successs
