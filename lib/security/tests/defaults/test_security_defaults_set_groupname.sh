#!/bin/bash

setup() {
  _fixture_mock_logs

  _mock.create getent
  _mock.create id

  RPI_SVC_USERNAME="mock_username"
}

@parametrize_with_uid_and_username_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "EXISTING_UID;EXISTING_USERNAME;EXPECTED_UID" \
    "existing_uid_matches_new_uid___;1001;new_user;1001" \
    "existing_uid_does_not_match_uid;1001;new_user;1002"
}

test_security_defaults_set_groupname__groupname_not_set____sets_group_name_to_user_primary_group() {
  RPI_SVC_GROUPNAME=""
  id.mock.set.stdout "expected_group"

  _security_defaults_set_groupname

  id.mock.assert_called_once_with "1(-gn) 2(${RPI_SVC_USERNAME})"
  assert_equals "expected_group" "${RPI_SVC_GROUPNAME}"
}

test_security_defaults_set_groupname__groupname_set________group_exists__________returns_status_code_0() {
  RPI_SVC_GROUPNAME="mock_group"
  getent.mock.set.rc 0

  _capture.rc _security_defaults_set_groupname

  assert_rc "0"
}

test_security_defaults_set_groupname__groupname_set________group_does_not_exist__returns_status_code_127() {
  RPI_SVC_GROUPNAME="mock_group"
  getent.mock.set.rc 1

  _capture.rc _security_defaults_set_groupname

  assert_rc "127"
}

test_security_defaults_set_groupname__groupname_set________group_does_not_exist__logs_expected_messages() {
  RPI_SVC_GROUPNAME="mock_group"
  getent.mock.set.rc 1

  _security_defaults_set_groupname

  _cli_log_error.mock.assert_called_once_with \
    "1(SECURITY: The specified group 'mock_group' (RPI_SVC_GROUPNAME) does not exist!)"
  _cli_log_info.mock.assert_called_once_with \
    "1(Please consider using the 'account' command to provision it.)"
}
