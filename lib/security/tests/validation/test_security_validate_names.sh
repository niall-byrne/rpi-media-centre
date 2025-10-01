#!/bin/bash

setup() {
  _fixture_mock_logs
}

@parametrize_with_invalid_names() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "RPI_SVC_USERNAME;RPI_SVC_GROUPNAME" \
    "invalid_username__invalid_group;root;root" \
    "valid_username____invalid_group;user;root" \
    "invalid_username__valid_group__;root;group"
}

test_security_validation_names__@vary__logs_error_messages() {
  _security_validation_names

  _cli_log_error.mock.assert_count_is "2"
  _cli_log_error.mock.assert_call_n_is "1" \
    "1(SECURITY: invalid configuration!)"
  _cli_log_error.mock.assert_call_n_is "2" \
    "1(Neither the 'RPI_SVC_GROUPNAME' or 'RPI_SVC_USERNAME' can be root.)"
}

@parametrize_with_invalid_names \
  test_security_validation_names__@vary__logs_error_messages

test_security_validation_names__@vary__return_status_code_127() {
  _capture.rc _security_validation_names

  assert_rc "127"
}

@parametrize_with_invalid_names \
  test_security_validation_names__@vary__return_status_code_127

# shellcheck disable=SC2034
test_security_validation_names__valid_username____valid_group__return_status_code_127() {
  RPI_SVC_USERNAME="user"
  RPI_SVC_GROUPNAME="group"

  _capture.rc _security_validation_names

  assert_rc "0"
}
