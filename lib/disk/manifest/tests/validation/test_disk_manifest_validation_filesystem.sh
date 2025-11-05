#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/disk/tests/__fakes__/crypt_data.sh"

setup_suite() {
  fake_disk_1

  _fixture_escape_rpi_vars
}

setup() {
  _mock.create stdlib.io.path.assert.is_folder
  _mock.create stdlib.security.path.query.is_secure
}

test_disk_manifest_validation_filesystem__not_folder__calls_is_folder_correctly() {
  stdlib.io.path.assert.is_folder.mock.set.rc 1

  _disk_manifest_validation_filesystem

  stdlib.io.path.assert.is_folder.mock.assert_called_once_with \
    "1(\${RPI_DISK_MOUNT_POINT})"
}

test_disk_manifest_validation_filesystem__not_folder__does_not_call_is_secure() {
  stdlib.io.path.assert.is_folder.mock.set.rc 1

  _disk_manifest_validation_filesystem

  stdlib.security.path.query.is_secure.mock.assert_not_called
}

test_disk_manifest_validation_filesystem__not_folder__returns_status_code_127() {
  stdlib.io.path.assert.is_folder.mock.set.rc 1

  _capture.rc _disk_manifest_validation_filesystem

  assert_rc "127"
}

test_disk_manifest_validation_filesystem__is_folder___not_secure__calls_is_folder_correctly() {
  stdlib.io.path.assert.is_folder.mock.set.rc 0
  stdlib.security.path.query.is_secure.mock.set.rc 1

  _disk_manifest_validation_filesystem

  stdlib.io.path.assert.is_folder.mock.assert_called_once_with \
    "1(\${RPI_DISK_MOUNT_POINT})"
}

test_disk_manifest_validation_filesystem__is_folder___not_secure__calls_is_secure_correctly() {
  stdlib.io.path.assert.is_folder.mock.set.rc 0
  stdlib.security.path.query.is_secure.mock.set.rc 1

  _disk_manifest_validation_filesystem

  stdlib.security.path.query.is_secure.mock.assert_called_once_with \
    "1(\${RPI_DISK_MOUNT_POINT}) 2(\${RPI_SVC_USERNAME}) 3(\${RPI_SVC_GROUPNAME}) 4(700)"
}

test_disk_manifest_validation_filesystem__is_folder___not_secure__returns_status_code_127() {
  stdlib.io.path.assert.is_folder.mock.set.rc 0
  stdlib.security.path.query.is_secure.mock.set.rc 1

  _capture.rc _disk_manifest_validation_filesystem

  assert_rc "127"
}

test_disk_manifest_validation_filesystem__is_folder___is_secure___calls_is_folder_correctly() {
  stdlib.io.path.assert.is_folder.mock.set.rc 0
  stdlib.security.path.query.is_secure.mock.set.rc 0

  _disk_manifest_validation_filesystem

  stdlib.io.path.assert.is_folder.mock.assert_called_once_with \
    "1(\${RPI_DISK_MOUNT_POINT})"
}

test_disk_manifest_validation_filesystem__is_folder___is_secure___calls_is_secure_correctly() {
  stdlib.io.path.assert.is_folder.mock.set.rc 0
  stdlib.security.path.query.is_secure.mock.set.rc 0

  _disk_manifest_validation_filesystem

  stdlib.security.path.query.is_secure.mock.assert_called_once_with \
    "1(\${RPI_DISK_MOUNT_POINT}) 2(\${RPI_SVC_USERNAME}) 3(\${RPI_SVC_GROUPNAME}) 4(700)"
}

test_disk_manifest_validation_filesystem__is_folder___is_secure___returns_status_code_0() {
  stdlib.io.path.assert.is_folder.mock.set.rc 0
  stdlib.security.path.query.is_secure.mock.set.rc 0

  _capture.rc _disk_manifest_validation_filesystem

  assert_rc "0"
}
