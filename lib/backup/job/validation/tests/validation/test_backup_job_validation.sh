#!/bin/bash

test_error_message="test error message"

setup() {
  _mock.create _backup_job_validation_argument_combinations
  _mock.create _cli_log_error
  _mock.create _cli_log_success
  _mock.create _backup_job_log
  _mock.create _backup_job_validation_argument
  _mock.create _backup_job_validation_dependency
  _mock.create _backup_job_validation_filesystem

  _mock.create _mock_help_fn

  _mock_help_fn.mock.set.stdout "${test_error_message}"
}

@parametrize_with_logging_toggle() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_JOB_LOGGING_BOOLEAN_VALUE" \
    "job_log_enabled_;1" \
    "job_log_disabled;0"
}

@parametrize_with_validator_sets() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_DISABLED_VALIDATOR_SET_DEFINITION;TEST_EXPECTED_VALIDATOR_SET_DEFINITION" \
    "default;;argument|dependency|filesystem" \
    "no_argument__dependency_____filesystem___;argument;dependency|filesystem" \
    "no_argument__no_dependency__filesystem___;argument|dependency;filesystem" \
    "no_argument__no_dependency__no_filesystem;argument|dependency|filesystem;;"
}

test_backup_job_validation__@vary__@vary__calls_backup_job_validation_argument_combinations() {
  local _RPI_BACKUP_JOB_DISABLED_VALIDATORS=()

  stdlib.array.make.from_string _RPI_BACKUP_JOB_DISABLED_VALIDATORS "|" "${TEST_DISABLED_VALIDATOR_SET_DEFINITION}"

  _backup_job_validation \
    _mock_help_fn \
    "${TEST_JOB_LOGGING_BOOLEAN_VALUE}" \
    2> /dev/null

  _backup_job_validation_argument_combinations.mock.assert_called_once_with ""
}

@parametrize.compose \
  test_backup_job_validation__@vary__@vary__calls_backup_job_validation_argument_combinations \
  @parametrize_with_logging_toggle \
  @parametrize_with_validator_sets

test_backup_job_validation__@vary__@vary__job_is_invalid__logs_error_message() {
  local _RPI_BACKUP_JOB_DISABLED_VALIDATORS=()

  _backup_job_validation_argument_combinations.mock.set.rc 1
  stdlib.array.make.from_string _RPI_BACKUP_JOB_DISABLED_VALIDATORS "|" "${TEST_DISABLED_VALIDATOR_SET_DEFINITION}"

  _backup_job_validation \
    _mock_help_fn \
    "${TEST_JOB_LOGGING_BOOLEAN_VALUE}" \
    2> /dev/null

  _cli_log_error.mock.assert_called_once_with \
    "1( -- BACKUP JOB: Backup Job is INVALID!)"
}

@parametrize.compose \
  test_backup_job_validation__@vary__@vary__job_is_invalid__logs_error_message \
  @parametrize_with_logging_toggle \
  @parametrize_with_validator_sets

test_backup_job_validation__@vary__@vary__job_is_invalid__generates_expected_stderr() {
  local _RPI_BACKUP_JOB_DISABLED_VALIDATORS=()

  _backup_job_validation_argument_combinations.mock.set.rc 1
  stdlib.array.make.from_string _RPI_BACKUP_JOB_DISABLED_VALIDATORS "|" "${TEST_DISABLED_VALIDATOR_SET_DEFINITION}"

  _capture.stderr _backup_job_validation \
    _mock_help_fn \
    "${TEST_JOB_LOGGING_BOOLEAN_VALUE}"

  assert_output "${test_error_message}"
}

@parametrize.compose \
  test_backup_job_validation__@vary__@vary__job_is_invalid__generates_expected_stderr \
  @parametrize_with_logging_toggle \
  @parametrize_with_validator_sets

test_backup_job_validation__@vary__@vary__job_is_invalid__generates_no_stdout() {
  local _RPI_BACKUP_JOB_DISABLED_VALIDATORS=()

  _backup_job_validation_argument_combinations.mock.set.rc 1
  stdlib.array.make.from_string _RPI_BACKUP_JOB_DISABLED_VALIDATORS "|" "${TEST_DISABLED_VALIDATOR_SET_DEFINITION}"

  _capture.stdout _backup_job_validation \
    _mock_help_fn \
    "${TEST_JOB_LOGGING_BOOLEAN_VALUE}"

  assert_output_null
}

@parametrize.compose \
  test_backup_job_validation__@vary__@vary__job_is_invalid__generates_no_stdout \
  @parametrize_with_logging_toggle \
  @parametrize_with_validator_sets

test_backup_job_validation__@vary__@vary__job_is_valid____logs_no_error_message() {
  local _RPI_BACKUP_JOB_DISABLED_VALIDATORS=()

  _backup_job_validation_argument_combinations.mock.set.rc 0
  stdlib.array.make.from_string _RPI_BACKUP_JOB_DISABLED_VALIDATORS "|" "${TEST_DISABLED_VALIDATOR_SET_DEFINITION}"

  _backup_job_validation \
    _mock_help_fn \
    "${TEST_JOB_LOGGING_BOOLEAN_VALUE}"

  _cli_log_error.mock.assert_not_called
}

@parametrize.compose \
  test_backup_job_validation__@vary__@vary__job_is_valid____logs_no_error_message \
  @parametrize_with_logging_toggle \
  @parametrize_with_validator_sets

test_backup_job_validation__job_log_enabled___@vary__job_is_valid____logs_success_message() {
  local _RPI_BACKUP_JOB_DISABLED_VALIDATORS=()

  _backup_job_validation_argument_combinations.mock.set.rc 0
  stdlib.array.make.from_string _RPI_BACKUP_JOB_DISABLED_VALIDATORS "|" "${TEST_DISABLED_VALIDATOR_SET_DEFINITION}"

  _backup_job_validation \
    _mock_help_fn \
    "1"

  _cli_log_success.mock.assert_called_once_with \
    "1( -- BACKUP JOB: Backup Job is VALID!)"
}

@parametrize.compose \
  test_backup_job_validation__job_log_enabled___@vary__job_is_valid____logs_success_message \
  @parametrize_with_validator_sets

test_backup_job_validation__job_log_enabled___@vary__job_is_valid____calls_backup_job_log() {
  local _RPI_BACKUP_JOB_DISABLED_VALIDATORS=()

  _backup_job_validation_argument_combinations.mock.set.rc 0
  stdlib.array.make.from_string _RPI_BACKUP_JOB_DISABLED_VALIDATORS "|" "${TEST_DISABLED_VALIDATOR_SET_DEFINITION}"

  _backup_job_validation \
    _mock_help_fn \
    "1"

  _backup_job_log.mock.assert_called_once_with ""
}

@parametrize.compose \
  test_backup_job_validation__job_log_enabled___@vary__job_is_valid____calls_backup_job_log \
  @parametrize_with_validator_sets

test_backup_job_validation__job_log_disabled__@vary__job_is_valid____does_not_log_success_message() {
  local _RPI_BACKUP_JOB_DISABLED_VALIDATORS=()

  _backup_job_validation_argument_combinations.mock.set.rc 0
  stdlib.array.make.from_string _RPI_BACKUP_JOB_DISABLED_VALIDATORS "|" "${TEST_DISABLED_VALIDATOR_SET_DEFINITION}"

  _backup_job_validation \
    _mock_help_fn \
    "0"

  _cli_log_success.mock.assert_not_called
}

@parametrize.compose \
  test_backup_job_validation__job_log_disabled__@vary__job_is_valid____does_not_log_success_message \
  @parametrize_with_validator_sets

test_backup_job_validation__@vary__@vary__job_is_valid____calls_expected_validators() {
  local _RPI_BACKUP_JOB_DISABLED_VALIDATORS=()
  local expected_validators=()
  local validator_name

  _backup_job_validation_argument_combinations.mock.set.rc 0
  stdlib.array.make.from_string _RPI_BACKUP_JOB_DISABLED_VALIDATORS "|" "${TEST_DISABLED_VALIDATOR_SET_DEFINITION}"
  stdlib.array.make.from_string expected_validators "|" "${TEST_EXPECTED_VALIDATOR_SET_DEFINITION}"

  _backup_job_validation \
    _mock_help_fn \
    "${TEST_JOB_LOGGING_BOOLEAN_VALUE}"

  for validator_name in "${expected_validators[@]}"; do
    "_backup_job_validation_${validator_name}.mock.assert_called_once_with" ""
  done
}

@parametrize.compose \
  test_backup_job_validation__@vary__@vary__job_is_valid____calls_expected_validators \
  @parametrize_with_logging_toggle \
  @parametrize_with_validator_sets
