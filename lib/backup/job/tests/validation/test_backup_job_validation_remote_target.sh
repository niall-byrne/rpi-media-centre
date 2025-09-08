#!/bin/bash

setup() {
  _mock.create _backup_job_validation_remote_parameters_s3
  _mock.create _dependencies_group_backups_aws
  _mock.create _cli_log_error
  _mock.create _backup_job_log
  _mock.create _backup_job_message_remote_target
}

@parametrize_with_valid_scenarios() {
  # $1: the test to parametrize

  @parametrize \
    "${1}" \
    "TEST_TARGET;TEST_PARAM;TEST_EXPECTED_RC" \
    "empty_target__;;;0" \
    "s3_target_____;s3://bucket;STANDARD;0"
}

@parametrize_with_invalid_scenario() {
  # $1: the test to parametrize

  @parametrize \
    "${1}" \
    "TEST_TARGET;TEST_PARAM;TEST_EXPECTED_RC" \
    "invalid_target;invalid;;127"
}

test_backup_job_validation_remote_target__@vary__@vary__returns_correct_exit_code() {
  _capture.rc _backup_job_validation_remote_target "${TEST_TARGET}" "${TEST_PARAM}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize.apply \
  test_backup_job_validation_remote_target__@vary__@vary__returns_correct_exit_code \
  @parametrize_with_valid_scenarios \
  @parametrize_with_invalid_scenario

test_backup_job_validation_remote_target__valid_scenarios___s3_target_______calls_dependencies_in_sequence() {
  _mock.sequence.record.start

  _backup_job_validation_remote_target "s3://bucket" "STANDARD"

  _mock.sequence.assert_is \
    "_backup_job_validation_remote_parameters_s3" \
    "_dependencies_group_backups_aws"
}

test_backup_job_validation_remote_target__valid_scenarios___s3_target_______calls_s3_param_validation_with_correct_arg() {
  _backup_job_validation_remote_target "s3://bucket" "STANDARD"

  _backup_job_validation_remote_parameters_s3.mock.assert_called_once_with \
    "1(STANDARD)"
}

test_backup_job_validation_remote_target__valid_scenarios___empty_target____does_not_call_dependencies() {
  _backup_job_validation_remote_target "" ""

  _backup_job_validation_remote_parameters_s3.mock.assert_not_called
  _dependencies_group_backups_aws.mock.assert_not_called
  _cli_log_error.mock.assert_not_called
}

test_backup_job_validation_remote_target__@vary___@vary__does_not_log_error() {
  _backup_job_validation_remote_target "${TEST_TARGET}" "${TEST_PARAM}"

  _cli_log_error.mock.assert_not_called
}

@parametrize.apply \
  test_backup_job_validation_remote_target__@vary___@vary__does_not_log_error \
  @parametrize_with_valid_scenarios

test_backup_job_validation_remote_target__@vary___@vary__generates_no_output() {
  _capture.output _backup_job_validation_remote_target "${TEST_TARGET}" "${TEST_PARAM}"

  assert_output_null
}

@parametrize.apply \
  test_backup_job_validation_remote_target__@vary___@vary__generates_no_output \
  @parametrize_with_valid_scenarios

test_backup_job_validation_remote_target__@vary__@vary__calls_dependencies_in_sequence() {
  _mock.sequence.record.start

  _backup_job_validation_remote_target "${TEST_TARGET}" "${TEST_PARAM}"

  _mock.sequence.assert_is \
    "_cli_log_error" \
    "_backup_job_log" \
    "_backup_job_message_remote_target"
}

@parametrize.apply \
  test_backup_job_validation_remote_target__@vary__@vary__calls_dependencies_in_sequence \
  @parametrize_with_invalid_scenario

test_backup_job_validation_remote_target__@vary__@vary__logs_error() {
  _backup_job_validation_remote_target "${TEST_TARGET}" "${TEST_PARAM}"

  _cli_log_error.mock.assert_called_once_with \
    "1( -- BACKUP JOB: Invalid remote storage target for this job.)"
}

@parametrize.apply \
  test_backup_job_validation_remote_target__@vary__@vary__logs_error \
  @parametrize_with_invalid_scenario

test_backup_job_validation_remote_target__@vary__@vary__redirects_stdout_stderr() {
  _backup_job_log.mock.set.stdout "backup_job_log"
  _backup_job_message_remote_target.mock.set.stdout "backup_job_message_remote_target"

  _capture.stderr _backup_job_validation_remote_target "${TEST_TARGET}" "${TEST_PARAM}"

  assert_output "backup_job_log
backup_job_message_remote_target"
}

@parametrize.apply \
  test_backup_job_validation_remote_target__@vary__@vary__redirects_stdout_stderr \
  @parametrize_with_invalid_scenario

test_backup_job_validation_remote_target__@vary__@vary__generates_no_stdout() {
  _backup_job_log.mock.set.stdout "backup_job_log"
  _backup_job_message_remote_target.mock.set.stdout "backup_job_message_remote_target"

  _capture.stdout _backup_job_validation_remote_target "${TEST_TARGET}" "${TEST_PARAM}"

  assert_output_null
}

@parametrize.apply \
  test_backup_job_validation_remote_target__@vary__@vary__generates_no_stdout \
  @parametrize_with_invalid_scenario
