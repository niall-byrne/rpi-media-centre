#!/bin/bash

# shellcheck disable=SC2034
setup_suite() {
  empty_array=()
}

setup() {
  _mock.create _backup_job_parse_destination_folders
  _mock.create _backup_job_validation
}

# shellcheck disable=SC2034
test_backup_manifest_line_validate__default_disabled_validators____calls_job_parse_destination_folders() {
  _backup_manifest_line_validate

  _backup_job_parse_destination_folders.mock.assert_called_once_with ""
}

# shellcheck disable=SC2034
test_backup_manifest_line_validate__default_disabled_validators____calls_job_validation_with_filesystem_checks_disabled() {
  _backup_job_validation.mock.set.keywords RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY

  _backup_manifest_line_validate

  _backup_job_validation.mock.assert_called_once_with \
    "1(_backup_manifest_line_log_invalid) RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY('filesystem')"
}

# shellcheck disable=SC2034
test_backup_manifest_line_validate__default_disabled_validators____executes_in_subshell() {
  _backup_job_validation.mock.set.keywords RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY

  _backup_manifest_line_validate

  stdlib.array.assert.not_array RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY
}

# shellcheck disable=SC2034
test_backup_manifest_line_validate__no_disabled_validators_________calls_job_parse_destination_folders() {
  local RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY=()

  _backup_manifest_line_validate

  _backup_job_parse_destination_folders.mock.assert_called_once_with ""
}

# shellcheck disable=SC2034
test_backup_manifest_line_validate__no_disabled_validators_________calls_job_validation_with_filesystem_checks_disabled() {
  local RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY=()

  _backup_job_validation.mock.set.keywords RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY

  _backup_manifest_line_validate

  _backup_job_validation.mock.assert_called_once_with \
    "1(_backup_manifest_line_log_invalid) RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY()"
}

# shellcheck disable=SC2034
test_backup_manifest_line_validate__no_disabled_validators_________executes_in_subshell() {
  local RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY=()

  _backup_job_validation.mock.set.keywords RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY

  _backup_manifest_line_validate

  assert_array_equals empty_array RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY
}

# shellcheck disable=SC2034
test_backup_manifest_line_validate__specified_disabled_validators__calls_job_parse_destination_folders() {
  local RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY=("mock_disabled_validator1" "mock_disabled_validator2")

  _backup_manifest_line_validate

  _backup_job_parse_destination_folders.mock.assert_called_once_with ""
}

# shellcheck disable=SC2034
test_backup_manifest_line_validate__specified_disabled_validators__calls_job_validation_with_filesystem_checks_disabled() {
  local RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY=("mock_disabled_validator1" "mock_disabled_validator2")

  _backup_job_validation.mock.set.keywords RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY

  _backup_manifest_line_validate

  _backup_job_validation.mock.assert_called_once_with \
    "1(_backup_manifest_line_log_invalid) RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY('mock_disabled_validator1' 'mock_disabled_validator2')"
}

# shellcheck disable=SC2034
test_backup_manifest_line_validate__specified_disabled_validators__executes_in_subshell() {
  local RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY=("mock_disabled_validator1" "mock_disabled_validator2")
  local expected_array=("${RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY[@]}")

  _backup_job_validation.mock.set.keywords RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY

  _backup_manifest_line_validate

  assert_array_equals expected_array RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY
}
