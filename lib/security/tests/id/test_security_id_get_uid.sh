#!/bin/bash

setup() {
  _mock.create id
}

test_security_id_get_uid__calls_id() {
  _security_id_get_uid "mock_username"

  id.mock.assert_called_once_with "-u mock_username"
}

test_security_id_get_uid__@vary__emits_id_output() {
  id.mock.set.stdout "${ID_STDOUT}"

  _capture_output _security_id_get_uid "mock_username"

  assert_equals "${ID_STDOUT}" "${TEST_OUTPUT}"
}

@parametrize \
  test_security_id_get_uid__@vary__emits_id_output \
  "ID_STDOUT," \
  "uid_501__,501" \
  "uid_1001_,1001"
