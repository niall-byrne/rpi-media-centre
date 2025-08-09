#!/bin/bash

setup() {
  _mock.create stdlib.security.get.gid
  _mock.create _security_warning_variable_mutated
}

@parametrize_with_gid_and_groupname_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "EXISTING_GID,EXISTING_GROUPNAME,EXPECTED_GID" \
    "existing_gid_matches_new_gid___,1001,new_group,1001" \
    "existing_gid_does_not_match_gid,1001,new_group,1002"
}

test_security_defaults_set_gid__@vary__calls_stdlib_security_get_gid() {
  # shellcheck disable=SC2034
  RPI_SVC_GROUPNAME="${EXISTING_GROUPNAME}"
  RPI_SVC_GID="${EXISTING_GID}"

  _security_defaults_set_gid

  stdlib.security.get.gid.mock.assert_called_once_with "${EXISTING_GROUPNAME}"
}

@parametrize_with_gid_and_groupname_combos \
  test_security_defaults_set_gid__@vary__calls_stdlib_security_get_gid

test_security_defaults_set_gid__@vary__security_warning_variable_mutated() {
  # shellcheck disable=SC2034
  RPI_SVC_GROUPNAME="${EXISTING_GROUPNAME}"
  RPI_SVC_GID="${EXISTING_GID}"

  _security_defaults_set_gid

  _security_warning_variable_mutated.mock.assert_called_once_with \
    "RPI_SVC_GID RPI_SVC_NEW_GID RPI_SVC_GROUPNAME"
}

@parametrize_with_gid_and_groupname_combos \
  test_security_defaults_set_gid__@vary__security_warning_variable_mutated

test_security_defaults_set_gid__@vary__sets_gid_correctly() {
  # shellcheck disable=SC2034
  RPI_SVC_GROUPNAME="${EXISTING_GROUPNAME}"
  RPI_SVC_GID="${EXISTING_GID}"
  stdlib.security.get.gid.mock.set.stdout "${EXPECTED_GID}"

  _security_defaults_set_gid

  assert_equals "${EXPECTED_GID}" "${RPI_SVC_GID}"
}

@parametrize_with_gid_and_groupname_combos \
  test_security_defaults_set_gid__@vary__sets_gid_correctly
