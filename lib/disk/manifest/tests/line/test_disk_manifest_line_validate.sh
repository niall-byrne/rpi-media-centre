#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/disk/manifest/tests/__fixtures__/disk_manifest_line_validate.sh"

setup_suite() {
  _fixture_escape_rpi_vars
}

setup() {
  _mock.create blkid
  _mock.create stdlib.io.path.assert.is_folder
  _mock.create stdlib.security.path.query.is_secure
  _mock.create _help_callback
}

test_disk_manifest_line_validate__mount_point_valid_____all_values__uuid_valid____return_code_0() {
  _fixture_disk_manifest_mount_point_conditions_valid
  _fixture_disk_manifest_uuid_conditions_valid

  _capture.rc _disk_manifest_line_validate _help_callback

  assert_rc "0"
}

test_disk_manifest_line_validate__mount_point_valid_____all_values__uuid_valid____does_not_call_help_function() {
  _fixture_disk_manifest_mount_point_conditions_valid
  _fixture_disk_manifest_uuid_conditions_valid

  _disk_manifest_line_validate _help_callback

  assert_equals "0" "$(_help_callback.mock.get.count)"
}

test_disk_manifest_line_validate__mount_point_missing___all_values__uuid_valid____return_code_127() {
  _fixture_disk_manifest_mount_point_conditions_valid
  _fixture_disk_manifest_uuid_conditions_valid
  stdlib.io.path.assert.is_folder.mock.set.rc "1"

  _capture.rc _disk_manifest_line_validate _help_callback

  stdlib.io.path.assert.is_folder.mock.assert_called_once_with "1(/mnt/mocked/path1)"
  assert_rc "127"
}

test_disk_manifest_line_validate__mount_point_missing___all_values__uuid_valid____calls_help_function() {
  _fixture_disk_manifest_mount_point_conditions_valid
  _fixture_disk_manifest_uuid_conditions_valid
  stdlib.io.path.assert.is_folder.mock.set.rc "1"

  _disk_manifest_line_validate _help_callback

  _help_callback.mock.assert_called_once_with ""
}

test_disk_manifest_line_validate__mount_point_insecure__all_values__uuid_valid____return_code_127() {
  _fixture_disk_manifest_mount_point_conditions_valid
  _fixture_disk_manifest_uuid_conditions_valid
  stdlib.security.path.query.is_secure.mock.set.rc "1"

  _capture.rc _disk_manifest_line_validate _help_callback

  stdlib.security.path.query.is_secure.mock.assert_called_once_with \
    "1(/mnt/mocked/path1) 2(${RPI_SVC_USERNAME}) 3(${RPI_SVC_GROUPNAME}) 4(700)"
  assert_rc "127"
}

test_disk_manifest_line_validate__mount_point_insecure__all_values__uuid_valid____calls_help_function() {
  _fixture_disk_manifest_mount_point_conditions_valid
  _fixture_disk_manifest_uuid_conditions_valid
  stdlib.security.path.query.is_secure.mock.set.rc "1"

  _disk_manifest_line_validate _help_callback

  _help_callback.mock.assert_called_once_with ""
}

test_disk_manifest_line_validate__mount_point_valid_____@vary__uuid_valid____return_code_127() {
  _fixture_disk_manifest_mount_point_conditions_valid
  blkid.mock.set.stdout "${RPI_DISK_MOUNT_POINT}"

  _capture.rc _disk_manifest_line_validate _help_callback

  assert_rc "127"
}

@parametrize_with_missing_values \
  test_disk_manifest_line_validate__mount_point_valid_____@vary__uuid_valid____return_code_127

test_disk_manifest_line_validate__mount_point_valid_____@vary__uuid_valid____calls_help_function() {
  _fixture_disk_manifest_mount_point_conditions_valid
  blkid.mock.set.stdout "${RPI_DISK_MOUNT_POINT}"

  _capture.rc _disk_manifest_line_validate _help_callback

  _help_callback.mock.assert_called_once_with ""
}

@parametrize_with_missing_values \
  test_disk_manifest_line_validate__mount_point_valid_____@vary__uuid_valid____calls_help_function

test_disk_manifest_line_validate__mount_point_valid_____all_values__uuid_invalid__return_code_0() {
  _fixture_disk_manifest_mount_point_conditions_valid
  _fixture_disk_manifest_uuid_conditions_valid
  blkid.mock.set.stdout ""

  _capture_logs _capture.rc _disk_manifest_line_validate _help_callback

  assert_rc "0"
}

test_disk_manifest_line_validate__mount_point_valid_____all_values__uuid_invalid__logs_a_warning() {
  _fixture_disk_manifest_mount_point_conditions_valid
  _fixture_disk_manifest_uuid_conditions_valid
  blkid.mock.set.stdout ""

  _capture_logs _disk_manifest_line_validate _help_callback

  _cli_log_warning.mock.assert_called_once_with \
    "1(DISK: UUID '${TEST_MOCK_UUID_1}' could not be found.)"
}
