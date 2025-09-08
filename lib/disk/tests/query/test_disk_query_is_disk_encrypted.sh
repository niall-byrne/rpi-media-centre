#!/bin/bash

setup() {
  _mock.create stdlib.io.path.query.is_file
}

test_is_disk_encrypted__file_exists__calls_test_as_expected() {
  stdlib.io.path.query.is_file.mock.set.rc 0

  _capture.rc _is_disk_encrypted

  stdlib.io.path.query.is_file.mock.assert_called_once_with "1(${RPI_MANIFEST_CRYPT})"
  assert_rc "0"
}

test_is_disk_encrypted__file_does_not_exist__calls_test_as_expected() {
  stdlib.io.path.query.is_file.mock.set.rc 1

  _capture.rc _is_disk_encrypted

  stdlib.io.path.query.is_file.mock.assert_called_once_with "1(${RPI_MANIFEST_CRYPT})"
  assert_rc "1"
}
