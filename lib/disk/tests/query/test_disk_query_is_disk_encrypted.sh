#!/bin/bash

setup() {
  _mock.create test
}

test_is_disk_encrypted__file_exists__calls_test_as_expected() {
  test.mock.set.rc 0

  _capture.rc _is_disk_encrypted

  assert_equals "1" "$(test.mock.get.count)"
  assert_equals "-f ${RPI_MANIFEST_CRYPT}" "$(test.mock.get.call "1")"
  assert_equals "0" "${TEST_RC}"
}

test_is_disk_encrypted__file_does_not_exist__calls_test_as_expected() {
  test.mock.set.rc 1

  _capture.rc _is_disk_encrypted

  assert_equals "1" "$(test.mock.get.count)"
  assert_equals "-f ${RPI_MANIFEST_CRYPT}" "$(test.mock.get.call "1")"
  assert_equals "1" "${TEST_RC}"
}
