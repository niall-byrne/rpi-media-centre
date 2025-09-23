#!/bin/bash

setup() {
  unset TEST_RECEIVED_FOLDER
  unset TEST_RECEIVED_PERMISSION
}

@parametrize_with_destination_folders() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_FOLDER;TEST_EXPECTED_FOLDER;TEST_EXPECTED_PERMISSION" \
    "valid_folder__valid_permission;/tarball:755;/tarball;755" \
    "valid_folder__no_permission___;/tarball::;/tarball;;" \
    "no_folder_____valid_permission;:755;;755" \
    "no_folder_____no_permission___;;;;"
}

# shellcheck disable=SC2034
test_backup_job_parse_destination_folders__@vary__assigns_expected_values() {
  _backup_job_parse_destination_folder_and_permission \
    "${TEST_FOLDER}" \
    "TEST_RECEIVED_FOLDER" \
    "TEST_RECEIVED_PERMISSION"

  assert_equals "${TEST_EXPECTED_FOLDER}" "${TEST_RECEIVED_FOLDER}"
  assert_equals "${TEST_EXPECTED_PERMISSION}" "${TEST_RECEIVED_PERMISSION}"
}

@parametrize_with_destination_folders \
  test_backup_job_parse_destination_folders__@vary__assigns_expected_values

# shellcheck disable=SC2034
test_backup_job_parse_destination_folders__too_many_values_________________does_not_assign_values() {
  TEST_FOLDER="/tarball:755:extra_value"

  _backup_job_parse_destination_folder_and_permission \
    "${TEST_FOLDER}" \
    "TEST_RECEIVED_FOLDER" \
    "TEST_RECEIVED_PERMISSION"

  assert_null "${TEST_EXPECTED_FOLDER}"
  assert_null "${TEST_EXPECTED_PERMISSION}"
}

# shellcheck disable=SC2034
test_backup_job_parse_destination_folders__too_few_values__________________does_not_assign_values() {
  TEST_FOLDER="/tarball"

  _backup_job_parse_destination_folder_and_permission \
    "${TEST_FOLDER}" \
    "TEST_RECEIVED_FOLDER" \
    "TEST_RECEIVED_PERMISSION"

  assert_null "${TEST_EXPECTED_FOLDER}"
  assert_null "${TEST_EXPECTED_PERMISSION}"
}
