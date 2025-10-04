#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/disk/tests/__fakes__/crypt_data.sh"
ORIGINAL_RPI_WORKING_DIRECTORY="${RPI_WORKING_DIRECTORY}"

setup_suite() {
  _fixture_escape_rpi_vars
}

setup() {
  _fixture_mock_logs
  _mock.create stdlib.security.path.query.is_secure
  _mock.create _disk_manifest_line_validate
  _mock.create _disk_manifest_line_invalid

  # shellcheck disable=SC2034
  RPI_DISK_UUID_SET=()
  # shellcheck disable=SC2034
  RPI_DISK_NAME_SET=()
  # shellcheck disable=SC2034
  RPI_DISK_CRYPT_GROUP_SET=()
  # shellcheck disable=SC2034
  RPI_DISK_MOUNT_POINT_SET=()
  # shellcheck disable=SC2034
  RPI_DISK_CRYPT_PASSWORD_SET=()
}

@parametrize_with_mock_manifests() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "RPI_MANIFEST_CRYPT;TEST_MANIFEST_LENGTH;EXPECTED_UUID_SET;EXPECTED_NAME_SET;EXPECTED_CRYPT_GROUP_SET;EXPECTED_MOUNT_POINT_SET" \
    "simple________manifest;${RPI_WORKING_DIRECTORY}/lib/disk/manifest/tests/__fixtures__/manifest1;1;UUID0;mocked_disk0;crypt_group0;/mnt/mocked/path0" \
    "comment_in____manifest;${RPI_WORKING_DIRECTORY}/lib/disk/manifest/tests/__fixtures__/manifest2;2;UUID0|UUID1;mocked_disk0|mocked_disk1;crypt_group0|crypt_group1;/mnt/mocked/path0|/mnt/mocked/path1" \
    "blank_line_in_manifest;${RPI_WORKING_DIRECTORY}/lib/disk/manifest/tests/__fixtures__/manifest3;3;UUID0|UUID1|UUID2;mocked_disk0|mocked_disk1|mocked_disk2;crypt_group0|crypt_group1|crypt_group2;/mnt/mocked/path0|/mnt/mocked/path1|/mnt/mocked/path2"
}

@parametrize_with_each_env_var() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "ENV_VAR_NAME;EXPECTED_VALUE_ENV_VAR_NAME" \
    "RPI_DISK_UUID_SET;RPI_DISK_UUID_SET;EXPECTED_UUID_SET" \
    "RPI_DISK_NAME_SET;RPI_DISK_NAME_SET;EXPECTED_NAME_SET" \
    "RPI_DISK_CRYPT_GROUP_SET;RPI_DISK_CRYPT_GROUP_SET;EXPECTED_CRYPT_GROUP_SET" \
    "RPI_DISK_MOUNT_POINT_SET;RPI_DISK_MOUNT_POINT_SET;EXPECTED_MOUNT_POINT_SET"
}

test_disk_manifest_load__@vary__logs_info_message() {
  _disk_manifest_load

  _cli_log_notice.mock.assert_called_once_with \
    "1(-- loading ${RPI_MANIFEST_CRYPT} file ... --)"
}

@parametrize_with_mock_manifests \
  test_disk_manifest_load__@vary__logs_info_message

test_disk_manifest_load__@vary__checks_manifest_permissions() {
  _disk_manifest_load

  stdlib.security.path.query.is_secure.mock.assert_called_once_with \
    "1(${RPI_MANIFEST_CRYPT}) 2(root) 3(root) 4(600)"
}

@parametrize_with_mock_manifests \
  test_disk_manifest_load__@vary__checks_manifest_permissions

test_disk_manifest_load__@vary__checks_each_line_for_validity() {
  local _MANIFEST_INDEX

  _disk_manifest_load

  assert_equals "${TEST_MANIFEST_LENGTH}" "$(_disk_manifest_line_validate.mock.get.count)"
  for ((_MANIFEST_INDEX = 1; _MANIFEST_INDEX != TEST_MANIFEST_LENGTH; _MANIFEST_INDEX++)); do
    _disk_manifest_line_validate.mock.assert_call_n_is "${_MANIFEST_INDEX}" \
      "1(_disk_manifest_line_invalid)"
  done
}

@parametrize_with_mock_manifests \
  test_disk_manifest_load__@vary__checks_each_line_for_validity

test_disk_manifest_load__@vary__sets_environment_variables_for_validity_check() {
  _disk_manifest_line_validate.mock.set.subcommand _disk_manifest_line_log

  _capture.output _disk_manifest_load

  assert_snapshot "${RPI_MANIFEST_CRYPT}".log
}

@parametrize_with_mock_manifests \
  test_disk_manifest_load__@vary__sets_environment_variables_for_validity_check

test_disk_manifest_load__@vary__@vary__is_correctly_populated() {
  # shellcheck disable=SC2034
  local TEST_VALUE_ARRAY=()

  stdlib.array.make.from_string TEST_VALUE_ARRAY "|" "${!EXPECTED_VALUE_ENV_VAR_NAME}"

  _disk_manifest_load

  assert_is_array TEST_VALUE_ARRAY
  assert_is_array "${ENV_VAR_NAME}"
  assert_array_equals TEST_VALUE_ARRAY "${ENV_VAR_NAME}"
}

@parametrize.compose \
  test_disk_manifest_load__@vary__@vary__is_correctly_populated \
  @parametrize_with_mock_manifests \
  @parametrize_with_each_env_var

test_disk_manifest_load__manifest_with_duplicate_names__calls_disk_manifest_line_invalid() {
  RPI_MANIFEST_CRYPT="${ORIGINAL_RPI_WORKING_DIRECTORY}/lib/disk/manifest/tests/__fixtures__/manifest-duplicate-names"

  _disk_manifest_load

  _disk_manifest_line_invalid.mock.assert_called_once_with ""
}

test_disk_manifest_load__manifest_with_duplicate_names__logs_an_error() {
  RPI_MANIFEST_CRYPT="${ORIGINAL_RPI_WORKING_DIRECTORY}/lib/disk/manifest/tests/__fixtures__/manifest-duplicate-names"

  _disk_manifest_load

  _cli_log_error.mock.assert_called_once_with \
    "1(The disk name 'mocked_disk1' is used multiple times, this value must be unique.)"
}
