#!/bin/bash

setup() {
  _mock.create _security_id_get_uid
  _mock.create _security_warning_variable_mutated
}

@parametrize_with_uid_and_username_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "EXISTING_UID,EXISTING_USERNAME,EXPECTED_UID" \
    "existing_uid_matches_new_uid___,1001,new_user,1001" \
    "existing_uid_does_not_match_uid,1001,new_user,1002"
}

test_security_defaults_set_uid__@vary__calls_security_id_get_uid() {
  # shellcheck disable=SC2034
  RPI_SVC_USERNAME="${EXISTING_USERNAME}"
  RPI_SVC_UID="${EXISTING_UID}"

  _security_defaults_set_uid

  _security_id_get_uid.mock.assert_called_once_with "${EXISTING_USERNAME}"
}

@parametrize_with_uid_and_username_combos \
  test_security_defaults_set_uid__@vary__calls_security_id_get_uid

test_security_defaults_set_uid__@vary__security_warning_variable_mutated() {
  # shellcheck disable=SC2034
  RPI_SVC_USERNAME="${EXISTING_USERNAME}"
  RPI_SVC_UID="${EXISTING_UID}"

  _security_defaults_set_uid

  _security_warning_variable_mutated.mock.assert_called_once_with \
    "RPI_SVC_UID RPI_SVC_NEW_UID RPI_SVC_USERNAME"
}

@parametrize_with_uid_and_username_combos \
  test_security_defaults_set_uid__@vary__security_warning_variable_mutated

test_security_defaults_set_uid__@vary__sets_uid_correctly() {
  # shellcheck disable=SC2034
  RPI_SVC_USERNAME="${EXISTING_USERNAME}"
  RPI_SVC_UID="${EXISTING_UID}"
  _security_id_get_uid.mock.set.stdout "${EXPECTED_UID}"

  _security_defaults_set_uid

  assert_equals "${EXPECTED_UID}" "${RPI_SVC_UID}"
}

@parametrize_with_uid_and_username_combos \
  test_security_defaults_set_uid__@vary__sets_uid_correctly
