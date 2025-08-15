#!/bin/bash

setup() {
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

  id.mock.assert_called_once_with "-gn ${RPI_SVC_USERNAME}"
  assert_equals "expected_group" "${RPI_SVC_GROUPNAME}"
}
