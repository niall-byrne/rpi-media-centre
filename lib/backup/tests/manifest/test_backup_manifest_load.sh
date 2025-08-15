#!/bin/bash

ORIGINAL_RPI_WORKING_DIRECTORY="${RPI_WORKING_DIRECTORY}"

setup_suite() {
  _fixture_escape_rpi_vars
}

# shellcheck disable=SC2034
setup() {
  _fixture_mock_logs
  _mock.create stdlib.security.path.query.is_secure
  _mock.create _backup_job_validation
  _mock.create _backup_manifest_help
  _mock.create _backup_manifest_line_invalid

  RPI_BACKUP_JOBS_NAMES=()
  RPI_BACKUP_JOBS_GROUPS=()
  RPI_BACKUP_JOBS_LOCAL_SOURCES=()
  RPI_BACKUP_JOBS_LOCAL_RSYNC_FOLDERS=()
  RPI_BACKUP_JOBS_LOCAL_TARBALL_FOLDERS=()
  RPI_BACKUP_JOBS_LOCAL_TARBALL_VERSIONS=()
  RPI_BACKUP_JOBS_REMOTE_ENCRYPTION_KEY_PATHS=()
  RPI_BACKUP_JOBS_REMOTE_TARGETS=()
  RPI_BACKUP_JOBS_REMOTE_PARAMETERS=()
}

@parametrize_with_non-existent-manifest() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "RPI_MANIFEST_BACKUP;" \
    "non-existent;${RPI_WORKING_DIRECTORY}/lib/backup/tests/manifest/__fixtures__/non-existent"
}

@parametrize_with_mock_manifests() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "RPI_MANIFEST_BACKUP;TEST_MANIFEST_LENGTH;EXPECTED_NAME_SET;EXPECTED_GROUP_SET;EXPECTED_SOURCE_GROUP_SET;EXPECTED_RSYNC_SET;EXPECTED_TARBALL_SET;EXPECTED_TARBELL_VERSION_SET;EXPECTED_KEY_SET;EXPECTED_REMOTE_SET;EXPECTED_REMOTE_PARAMETER_SET" \
    "simple_manifest;${RPI_WORKING_DIRECTORY}/lib/backup/tests/manifest/__fixtures__/manifest1;2;test1|test2;yearly|daily;/path/folder1|/path/folder2;/path/rsync1||;|/path/tarball1;|4;/path/key1||;s3://bucket/path1|s3://bucket/path1/path2;||" \
    "blank_line_manifest;${RPI_WORKING_DIRECTORY}/lib/backup/tests/manifest/__fixtures__/manifest2;2;test1|test2;yearly|daily;/path/folder1|/path/folder2;|/path/rsync2|;|/path/tarball1;|4;/path/key1|/path/key2;s3://bucket/path1|s3://bucket/path1/path2;GLACIER||" \
    "commented_line_manifest;${RPI_WORKING_DIRECTORY}/lib/backup/tests/manifest/__fixtures__/manifest3;2;test1|test2;yearly|daily;/path/folder1|/path/folder2;|/path/rsync2|;|/path/tarball1;|4;/path/key1|/path/key2;s3://bucket/path1|s3://bucket/path1/path2;GLACIER||"
}

@parametrize_with_each_env_var() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "ENV_VAR_NAME;EXPECTED_VALUE_ENV_VAR_NAME" \
    "RPI_BACKUP_JOBS_NAMES;RPI_BACKUP_JOBS_NAMES;EXPECTED_NAME_SET" \
    "RPI_BACKUP_JOBS_GROUPS;RPI_BACKUP_JOBS_GROUPS;EXPECTED_GROUP_SET" \
    "RPI_BACKUP_JOBS_LOCAL_SOURCES;RPI_BACKUP_JOBS_LOCAL_SOURCES;EXPECTED_SOURCE_GROUP_SET" \
    "RPI_BACKUP_JOBS_LOCAL_RSYNC_FOLDERS;RPI_BACKUP_JOBS_LOCAL_RSYNC_FOLDERS;EXPECTED_RSYNC_SET" \
    "RPI_BACKUP_JOBS_LOCAL_TARBALL_FOLDERS;RPI_BACKUP_JOBS_LOCAL_TARBALL_FOLDERS;EXPECTED_TARBALL_SET" \
    "RPI_BACKUP_JOBS_LOCAL_TARBALL_VERSIONS;RPI_BACKUP_JOBS_LOCAL_TARBALL_VERSIONS;EXPECTED_TARBELL_VERSION_SET" \
    "RPI_BACKUP_JOBS_REMOTE_ENCRYPTION_KEY_PATHS;RPI_BACKUP_JOBS_REMOTE_ENCRYPTION_KEY_PATHS;EXPECTED_KEY_SET" \
    "RPI_BACKUP_JOBS_REMOTE_TARGETS;RPI_BACKUP_JOBS_REMOTE_TARGETS;EXPECTED_REMOTE_SET" \
    "RPI_BACKUP_JOBS_REMOTE_PARAMETERS;RPI_BACKUP_JOBS_REMOTE_PARAMETERS;EXPECTED_REMOTE_PARAMETER_SET"
}

test_backup_manifest_load__@vary__logs_info_message() {
  _backup_manifest_load

  _cli_log_notice.mock.assert_called_once_with \
    "-- loading ${RPI_MANIFEST_BACKUP} file ... --"
}

@parametrize_with_mock_manifests \
  test_backup_manifest_load__@vary__logs_info_message

test_backup_manifest_load__@vary__logs_error_message() {
  RPI_MANIFEST_BACKUP="${ORIGINAL_RPI_WORKING_DIRECTORY}/lib/backup/tests/manifest/__fixtures__/non-existent-manifest"

  _backup_manifest_load

  _cli_log_error.mock.assert_called_once_with \
    "Please create the ${RPI_MANIFEST_BACKUP} file to use this feature."
}

@parametrize_with_non-existent-manifest \
  test_backup_manifest_load__@vary__logs_error_message

test_backup_manifest_load__@vary__calls_backup_manifest_help() {
  RPI_MANIFEST_BACKUP="${ORIGINAL_RPI_WORKING_DIRECTORY}/lib/backup/tests/manifest/__fixtures__/non-existent-manifest"

  _backup_manifest_load

  _backup_manifest_help.mock.assert_called_once_with ""
}

@parametrize_with_non-existent-manifest \
  test_backup_manifest_load__@vary__calls_backup_manifest_help

test_backup_manifest_load__@vary__returns_code_127() {
  RPI_MANIFEST_BACKUP="${ORIGINAL_RPI_WORKING_DIRECTORY}/lib/backup/tests/manifest/__fixtures__/non-existent-manifest"

  _capture.rc _backup_manifest_load

  assert_rc "127"
}

@parametrize_with_non-existent-manifest \
  test_backup_manifest_load__@vary__returns_code_127

test_backup_manifest_load__@vary__checks_manifest_permissions() {
  _backup_manifest_load

  stdlib.security.path.query.is_secure.mock.assert_called_once_with \
    "${RPI_MANIFEST_BACKUP} root root 600"
}

@parametrize_with_mock_manifests \
  test_backup_manifest_load__@vary__checks_manifest_permissions

test_backup_manifest_load__@vary__checks_each_line_for_validity() {
  local _MANIFEST_INDEX

  _backup_manifest_load

  assert_equals "${TEST_MANIFEST_LENGTH}" "$(_backup_job_validation.mock.get.count)"
  for ((_MANIFEST_INDEX = 1; _MANIFEST_INDEX != TEST_MANIFEST_LENGTH; _MANIFEST_INDEX++)); do
    assert_equals "_backup_manifest_line_invalid" "$(_backup_job_validation.mock.get.call "${_MANIFEST_INDEX}")"
  done
}

@parametrize_with_mock_manifests \
  test_backup_manifest_load__@vary__checks_each_line_for_validity

test_backup_manifest_load__@vary__sets_environment_variables_for_validity_check() {
  _backup_job_validation.mock.set.subcommand _backup_manifest_line_log_all

  _capture.output _backup_manifest_load

  assert_output "$(cat "${RPI_MANIFEST_BACKUP}.log")"
}

@parametrize_with_mock_manifests \
  test_backup_manifest_load__@vary__sets_environment_variables_for_validity_check

test_backup_manifest_load__@vary__@vary__is_correctly_populated() {
  # shellcheck disable=SC2034
  local TEST_VALUE_ARRAY=()

  stdlib.array.make.from_string TEST_VALUE_ARRAY "|" "${!EXPECTED_VALUE_ENV_VAR_NAME}"

  _backup_manifest_load

  assert_is_array TEST_VALUE_ARRAY
  assert_is_array "${ENV_VAR_NAME}"
  assert_array_equals TEST_VALUE_ARRAY "${ENV_VAR_NAME}"
}

@parametrize.compose \
  test_backup_manifest_load__@vary__@vary__is_correctly_populated \
  @parametrize_with_mock_manifests \
  @parametrize_with_each_env_var

test_backup_manifest_load__manifest_with_duplicate_job_names__calls_backup_manifest_line_invalid() {
  RPI_MANIFEST_BACKUP="${ORIGINAL_RPI_WORKING_DIRECTORY}/lib/backup/tests/manifest/__fixtures__/manifest-duplicate-job-names"

  _backup_manifest_load

  _backup_manifest_line_invalid.mock.assert_called_once_with ""
}

test_backup_manifest_load__manifest_with_duplicate_names__logs_an_error() {
  RPI_MANIFEST_BACKUP="${ORIGINAL_RPI_WORKING_DIRECTORY}/lib/backup/tests/manifest/__fixtures__/manifest-duplicate-job-names"

  _backup_manifest_load

  _cli_log_error.mock.assert_called_once_with \
    "The backup job name 'test_duplicate' is used multiple times, this value must be unique."
}
