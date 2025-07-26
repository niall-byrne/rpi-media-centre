#!/bin/bash

setup() {
  _mock.create getent
}

test_security_id_get_gid__calls_getent() {
  _security_id_get_gid "mock_groupname"

  getent.mock.assert_called_once_with "group mock_groupname"
}

test_security_id_get_gid__@vary__emits_parsed_getent_output() {
  getent.mock.set.stdout "${GETENT_STDOUT}"

  _capture_output _security_id_get_gid "mock_groupname"

  assert_equals "${EXPECTED_GID}" "${TEST_OUTPUT}"
}

@parametrize \
  test_security_id_get_gid__@vary__emits_parsed_getent_output \
  "GETENT_STDOUT,EXPECTED_GID" \
  "gid_501_____,mock_groupname:x:501:,501" \
  "gid_1001____,mock_groupname:x:1001:,1001"
