#!/bin/bash

setup() {
  _fixture_mock_logs

  _mock.create _security_validate_ids_relationship
}

@parametrize_invalid_uid_gid_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "RPI_SVC_GID;RPI_SVC_UID" \
    "invalid_gid__valid_uid__;0;1000" \
    "valid_gid____invalid_uid;1000;0" \
    "invalid_gid__invalid_uid;0;0"
}

test_security_validate_ids__@vary__logs_error_messages() {
  _security_validate_ids

  _cli_log_error.mock.assert_count_is "2"
  _cli_log_error.mock.assert_call_n_is "1" "1(SECURITY: invalid configuration!)"
  _cli_log_error.mock.assert_call_n_is "2" "1(Neither the 'RPI_SVC_GID' or 'RPI_SVC_UID' can be zero.)"
}

@parametrize_invalid_uid_gid_combos \
  test_security_validate_ids__@vary__logs_error_messages

test_security_validate_ids__@vary__does_not_call_security_validate_ids_relationship() {
  _security_validate_ids

  _security_validate_ids_relationship.mock.assert_count_is "0"
}

@parametrize_invalid_uid_gid_combos \
  test_security_validate_ids__@vary__does_not_call_security_validate_ids_relationship

test_security_validate_ids__@vary__returns_correct_status_code() {
  _capture.rc _security_validate_ids

  assert_rc "127"
}

@parametrize_invalid_uid_gid_combos \
  test_security_validate_ids__@vary__returns_correct_status_code

test_security_validate_ids__valid_gid____valid_uid____calls_security_validate_ids_relationship() {
  # shellcheck disable=SC2034
  local RPI_SVC_GID=1000
  # shellcheck disable=SC2034
  local RPI_SVC_UID=1000

  _security_validate_ids

  _security_validate_ids_relationship.mock.assert_count_is "2"
  _security_validate_ids_relationship.mock.assert_call_n_is "1" \
    "1(RPI_SVC_GID) 2(RPI_SVC_GROUPNAME) 3(group)"
  _security_validate_ids_relationship.mock.assert_call_n_is "2" \
    "1(RPI_SVC_UID) 2(RPI_SVC_USERNAME) 3(user)"
}

test_security_validate_ids__valid_gid____valid_uid____returns_correct_status_code() {
  # shellcheck disable=SC2034
  local RPI_SVC_GID=1000
  # shellcheck disable=SC2034
  local RPI_SVC_UID=1000

  _capture.rc _security_validate_ids

  assert_rc "0"
}
