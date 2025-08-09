#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/disk/tests/manifest/__fixtures__/disk_manifest_line_validate.sh"

setup_suite() {
  _fixture_escape_rpi_vars
}

setup() {
  _mock.create blkid
  _mock.create _filesystem_check_is_folder
  _mock.create _security_path_check
  _mock.create _help_callback
}

test_disk_manifest_line_validate__mount_point_valid_____all_values__uuid_valid____return_code_0() {
  _fixture_disk_manifest_mount_point_conditions_valid
  _fixture_disk_manifest_uuid_conditions_valid

  _capture.rc _disk_manifest_line_validate _help_callback

  assert_equals "0" "${TEST_RC}"
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
  _filesystem_check_is_folder.mock.set.rc "1"

  _capture.rc _disk_manifest_line_validate _help_callback

  assert_equals "1" "$(_filesystem_check_is_folder.mock.get.count)"
  assert_equals \
    "/mnt/mocked/path1" \
    "$(_filesystem_check_is_folder.mock.get.calls)"
  assert_equals "127" "${TEST_RC}"
}

test_disk_manifest_line_validate__mount_point_missing___all_values__uuid_valid____calls_help_function() {
  _fixture_disk_manifest_mount_point_conditions_valid
  _fixture_disk_manifest_uuid_conditions_valid
  _filesystem_check_is_folder.mock.set.rc "1"

  _disk_manifest_line_validate _help_callback

  assert_equals "1" "$(_help_callback.mock.get.count)"
  assert_equals "" "$(_help_callback.mock.get.call "1")"
}

test_disk_manifest_line_validate__mount_point_insecure__all_values__uuid_valid____return_code_127() {
  _fixture_disk_manifest_mount_point_conditions_valid
  _fixture_disk_manifest_uuid_conditions_valid
  _security_path_check.mock.set.rc "1"

  _capture.rc _disk_manifest_line_validate _help_callback

  assert_equals "1" "$(_security_path_check.mock.get.count)"
  assert_equals \
    "/mnt/mocked/path1 ${RPI_SVC_USERNAME} ${RPI_SVC_GROUPNAME} 700" \
    "$(_security_path_check.mock.get.calls)"
  assert_equals "127" "${TEST_RC}"
}

test_disk_manifest_line_validate__mount_point_insecure__all_values__uuid_valid____calls_help_function() {
  _fixture_disk_manifest_mount_point_conditions_valid
  _fixture_disk_manifest_uuid_conditions_valid
  _security_path_check.mock.set.rc "1"

  _disk_manifest_line_validate _help_callback

  assert_equals "1" "$(_help_callback.mock.get.count)"
  assert_equals "" "$(_help_callback.mock.get.call "1")"
}

test_disk_manifest_line_validate__mount_point_valid_____@vary__uuid_valid____return_code_127() {
  _fixture_disk_manifest_mount_point_conditions_valid
  blkid.mock.set.stdout "${RPI_DISK_MOUNT_POINT}"

  _capture.rc _disk_manifest_line_validate _help_callback

  assert_equals "127" "${TEST_RC}"
}

@parametrize_with_missing_values \
  test_disk_manifest_line_validate__mount_point_valid_____@vary__uuid_valid____return_code_127

test_disk_manifest_line_validate__mount_point_valid_____@vary__uuid_valid____calls_help_function() {
  _fixture_disk_manifest_mount_point_conditions_valid
  blkid.mock.set.stdout "${RPI_DISK_MOUNT_POINT}"

  _capture.rc _disk_manifest_line_validate _help_callback

  assert_equals "1" "$(_help_callback.mock.get.count)"
  assert_equals "" "$(_help_callback.mock.get.call "1")"
}

@parametrize_with_missing_values \
  test_disk_manifest_line_validate__mount_point_valid_____@vary__uuid_valid____calls_help_function

test_disk_manifest_line_validate__mount_point_valid_____all_values__uuid_invalid__return_code_0() {
  _fixture_disk_manifest_mount_point_conditions_valid
  _fixture_disk_manifest_uuid_conditions_valid
  blkid.mock.set.stdout ""

  _capture_logs _capture.rc _disk_manifest_line_validate _help_callback

  assert_equals "0" "${TEST_RC}"
}

test_disk_manifest_line_validate__mount_point_valid_____all_values__uuid_invalid__logs_a_warning() {
  _fixture_disk_manifest_mount_point_conditions_valid
  _fixture_disk_manifest_uuid_conditions_valid
  blkid.mock.set.stdout ""

  _capture_logs _disk_manifest_line_validate _help_callback

  assert_equals "1" "$(_cli_log_warning.mock.get.count)"
  assert_equals \
    "DISK: UUID '${TEST_MOCK_UUID_1}' could not be found." \
    "$(_cli_log_warning.mock.get.call "1")"
}
