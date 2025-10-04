#!/bin/bash

setup() {
  _fixture_mock_logs
  _mock.create _security_defaults_set
}

@parametrize_with_sum_warning() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "RPI_SVC_USERNAME;SUDO_USER;RPI_DISABLE_SINGLE_USER_MODE_WARNING_BOOLEAN" \
    "single_user_mode___warning_enabled_;admin_user;admin_user;;"
}

@parametrize_with_sum_warning_bypass() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "RPI_SVC_USERNAME;SUDO_USER;RPI_DISABLE_SINGLE_USER_MODE_WARNING_BOOLEAN" \
    "single_user_mode___warning_disabled;admin_user;admin_user;1;" \
    "service_user_mode__warning_disabled;user;admin_user;;" \
    "service_user_mode__warning_enable__;user;admin_user;1;"
}

test_security_warning_single_user_mode__@vary__@vary__calls_security_defaults_set() {
  _security_warning_single_user_mode

  _security_defaults_set.mock.assert_called_once_with ""
}

@parametrize.apply \
  test_security_warning_single_user_mode__@vary__@vary__calls_security_defaults_set \
  @parametrize_with_sum_warning \
  @parametrize_with_sum_warning_bypass

test_security_warning_single_user_mode__sum_warning_________@vary__logs_warning_messages() {
  local RPI_MANIFEST_CONFIG="/mock/path"
  local EXPECTED_WARNING_MESSAGES=(
    "1(SECURITY: pictl is running in single user mode)"
    "1(  Concurrent user access is not supported.)"
  )
  local EXPECTED_INFO_MESSAGES=(
    "1(Consider appending the following to your ${RPI_MANIFEST_CONFIG} file:)"
    '1(  RPI_SVC_USERNAME="service_account_username")'
    "1(Please see the documentation for further details or to learn how to silence this warning.)"
  )

  _security_warning_single_user_mode

  _cli_log_warning.mock.assert_calls_are "${EXPECTED_WARNING_MESSAGES[@]}"
  _cli_log_info.mock.assert_calls_are "${EXPECTED_INFO_MESSAGES[@]}"
}

@parametrize_with_sum_warning \
  test_security_warning_single_user_mode__sum_warning_________@vary__logs_warning_messages

test_security_warning_single_user_mode__sum_warning_bypass__@vary__does_not_log_warning_messages() {
  _security_warning_single_user_mode

  _cli_log_warning.mock.assert_not_called
  _cli_log_info.mock.assert_not_called
}

@parametrize_with_sum_warning_bypass \
  test_security_warning_single_user_mode__sum_warning_bypass__@vary__does_not_log_warning_messages
