#!/bin/bash

setup() {
  _fixture_mock_logs
  _mock.create getent
  _mock.create id
  _mock.create _security_account_provision_service_account_group
  _mock.create _security_account_provision_service_account_username

  # shellcheck disable=SC2034
  SUDO_USER="admin"
}

@parametrize_username_invalid() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "RPI_SVC_USERNAME" \
    "not_set__,," \
    "sudo_user,admin,"
}

@parametrize_username_group_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "RPI_SVC_USERNAME,RPI_SVC_GROUPNAME,TEST_GETENT_RC,TEST_EXPECTED_SVC_USERNAME,TEST_EXPECTED_SVC_GROUPNAME" \
    "username_not_found___group_not_set,new_user,,1,new_user,new_user" \
    "username_found_______group_not_set,new_user,,0,new_user,new_user_primary_group" \
    "username_found_______group_set____,new_user,new_group,0,new_user,new_group"
}

test_security_account_provision_service_account__username_@vary___return_code_127() {

  _capture.rc _security_account_provision_service_account

  assert_rc "127"
}

@parametrize_username_invalid \
  test_security_account_provision_service_account__username_@vary___return_code_127

test_security_account_provision_service_account__username_@vary___logs_error() {
  _security_account_provision_service_account

  assert_equals "1" "$(_cli_log_error.mock.get.count)"
  assert_equals \
    "SECURITY: You must specify the RPI_SVC_USERNAME to provision a service account." \
    "$(_cli_log_error.mock.get.call "1")"
}

@parametrize_username_invalid \
  test_security_account_provision_service_account__username_@vary___logs_error

test_security_account_provision_service_account__@vary__logs_expected_messages() {
  getent.mock.set.rc "${TEST_GETENT_RC}"
  id.mock.set.stdout "new_user_primary_group"

  _security_account_provision_service_account

  assert_equals "1" "$(_cli_log_success.mock.get.count)"
  assert_equals \
    "SECURITY: The service account has been successfully provisioned." \
    "$(_cli_log_success.mock.get.call "1")"
  assert_equals "2" "$(_cli_log_info.mock.get.count)"
  assert_equals \
    "If this is the service account you wish to use it must be able to read your media file." \
    "$(_cli_log_info.mock.get.call "1")"
  assert_equals \
    "Please consider: sudo chown -R ${TEST_EXPECTED_SVC_USERNAME}:${TEST_EXPECTED_SVC_GROUPNAME} ${RPI_ROOT}/shared/media" \
    "$(_cli_log_info.mock.get.call "2")"
}

@parametrize_username_group_combos \
  test_security_account_provision_service_account__@vary__logs_expected_messages

test_security_account_provision_service_account__@vary__provisions_service_account_correctly() {
  # shellcheck disable=SC2034
  getent.mock.set.rc "${TEST_GETENT_RC}"
  id.mock.set.stdout "new_user_primary_group"

  _security_account_provision_service_account

  assert_equals "1" "$(_security_account_provision_service_account_group.mock.get.count)"
  assert_equals "${TEST_EXPECTED_SVC_GROUPNAME}" "$(_security_account_provision_service_account_group.mock.get.call "1")"
  assert_equals "1" "$(_security_account_provision_service_account_username.mock.get.count)"
  assert_equals "${TEST_EXPECTED_SVC_USERNAME}" "$(_security_account_provision_service_account_username.mock.get.call "1")"
}

@parametrize_username_group_combos \
  test_security_account_provision_service_account__@vary__provisions_service_account_correctly
