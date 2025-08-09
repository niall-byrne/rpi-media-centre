#!/bin/bash

setup() {
  _fixture_mock_logs
  _mock.create id

  SUDO_USER="admin"
  RPI_SVC_USERNAME=""
  RPI_SVC_GROUPNAME=""
}

test_security_defaults_set_username__username_not_set__groupname_not_set________not_service_mode__falls_back_to_sudo_user() {
  _security_defaults_set_username

  assert_equals "${SUDO_USER}" "${RPI_SVC_USERNAME}"
}

test_security_defaults_set_username__username_not_set__groupname_set____________logs_error_message() {
  # shellcheck disable=SC2034
  RPI_SVC_GROUPNAME="mocked_groupname"
  EXPECTED_LOGGING_CALLS=(
    "SECURITY: invalid configuration!"
    "The 'RPI_SVC_GROUPNAME' is specified without 'RPI_SVC_USERNAME'."
  )

  _security_defaults_set_username

  _cli_log_error.mock.assert_calls_are "${EXPECTED_LOGGING_CALLS[@]}"
}

test_security_defaults_set_username__username_not_set__groupname_set____________return_code_127() {
  # shellcheck disable=SC2034
  RPI_SVC_GROUPNAME="mocked_groupname"

  _capture.rc _security_defaults_set_username

  assert_rc "127"
}

test_security_defaults_set_username__username_set______calls_id() {
  RPI_SVC_USERNAME="mocked_username"
  id.mock.set.rc 0

  _security_defaults_set_username

  id.mock.assert_called_once_with "${RPI_SVC_USERNAME}"
}

test_security_defaults_set_username__username_set______username_exists__________return_code_0() {
  RPI_SVC_USERNAME="mocked_username"
  id.mock.set.rc 0

  _capture.rc _security_defaults_set_username

  assert_rc "0"
}

test_security_defaults_set_username__username_set______username_does_not_exist__logs_error_message() {
  RPI_SVC_USERNAME="mocked_username"
  id.mock.set.rc 1

  _security_defaults_set_username

  _cli_log_error.mock.assert_called_once_with \
    "SECURITY: The specified user '${RPI_SVC_USERNAME}' (RPI_SVC_USERNAME) does not exist!"
  _cli_log_info.mock.assert_called_once_with \
    "Please consider using the 'account' command to provision it."
}

test_security_defaults_set_username__username_set______username_does_not_exist__return_code_127() {
  RPI_SVC_USERNAME="mocked_username"
  id.mock.set.rc 1

  _capture.rc _security_defaults_set_username

  assert_rc "127"
}
