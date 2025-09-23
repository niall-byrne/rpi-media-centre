#!/bin/bash

# shellcheck disable=SC2034
setup_suite() {
  test_error_messages=(
    "test error message 1"
    "test error message 2"
    "test error message 3"
  )
}

setup() {
  _mock.create _cli_log_error
  _mock.create _backup_job_log

  _mock.create _mock_error_fn_1
  _mock.create _mock_error_fn_2

  _backup_job_log.mock.set.stdout "${test_error_messages[0]}"

  _mock_error_fn_1.mock.set.stdout "${test_error_messages[1]}"
  _mock_error_fn_2.mock.set.stdout "${test_error_messages[2]}"
}

@parametrize_with_mock_error_content() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ERROR_MSG;TEST_FN;TEST_ERROR_MESSAGE_INDEX" \
    "mock_error_content_1;mock error 1!;_mock_error_fn_1;1" \
    "mock_error_content_2;mock error 2!;_mock_error_fn_2;2"
}

test_backup_job_validation_error__@vary__returns_status_code_127() {
  _capture.rc _backup_job_validation_error "${TEST_ERROR_MSG}" "${TEST_FN}" 2> /dev/null

  assert_rc 127
}

@parametrize_with_mock_error_content \
  test_backup_job_validation_error__@vary__returns_status_code_127

test_backup_job_validation_error__@vary__logs_expected_error() {
  _backup_job_validation_error "${TEST_ERROR_MSG}" "${TEST_FN}" 2> /dev/null

  _cli_log_error.mock.assert_called_once_with "1( -- BACKUP JOB: ${TEST_ERROR_MSG})"
}

@parametrize_with_mock_error_content \
  test_backup_job_validation_error__@vary__logs_expected_error

test_backup_job_validation_error__@vary__generates_expected_stderr_content() {
  _capture.stderr _backup_job_validation_error "${TEST_ERROR_MSG}" "${TEST_FN}" 2> /dev/null

  assert_output "${test_error_messages[0]}"$'\n'"${test_error_messages[${TEST_ERROR_MESSAGE_INDEX}]}"
}

@parametrize_with_mock_error_content \
  test_backup_job_validation_error__@vary__generates_expected_stderr_content

test_backup_job_validation_error__@vary__generates_no_stdout() {
  _capture.stdout _backup_job_validation_error "${TEST_ERROR_MSG}" "${TEST_FN}" 2> /dev/null

  assert_output_null
}

@parametrize_with_mock_error_content \
  test_backup_job_validation_error__@vary__generates_no_stdout
