#!/bin/bash

setup() {
  _fixture_mock_logs

  _mock.create _io_ensure_vars_set
  _mock.create stat
}

test_security_path_check_permissions__@vary__calls_io_ensure_vars_set() {
  _array_from_string TEST_ARGUMENTS "|" "${TEST_ARGUMENT_DEFINITION}"

  _security_path_check_permissions "${TEST_ARGUMENTS[@]}"

  _io_ensure_vars_set.mock.assert_called_once_with "2 ${EXPECTED_ARGS}"
}

@parametrize \
  "test_security_path_check_permissions__@vary__calls_io_ensure_vars_set" \
  "TEST_ARGUMENT_DEFINITION,EXPECTED_ARGS" \
  "valid_arguments,/mnt/path1|644,/mnt/path1 644" \
  "omitted_octal__,/mnt/path1||,/mnt/path1 " \
  "omitted_path___,|644|, 644"

test_security_path_check_permissions__valid_arguments__@vary__calls_stat() {
  stat.mock.set.stdout "${TEST_STAT_PERMISSIONS}"

  _security_path_check_permissions "/mnt/path1" "644"

  stat.mock.assert_called_once_with "${TEST_CALL_ARGS}"
}

@parametrize \
  "test_security_path_check_permissions__valid_arguments__@vary__calls_stat" \
  "TEST_STAT_PERMISSIONS,TEST_CALL_ARGS" \
  "correct_permissions__,644,-c %a /mnt/path1" \
  "incorrect_permissions,755,-c %a /mnt/path1"

test_security_path_check_permissions__valid_arguments__@vary__logs_error_message() {
  stat.mock.set.stdout "${TEST_STAT_PERMISSIONS}"

  _security_path_check_permissions "/mnt/path1" "644"

  _cli_log_error.mock.assert_called_once_with "${TEST_ERROR_LOG}"
  _cli_log_info.mock.assert_called_once_with "${TEST_INFO_LOG}"
}

@parametrize \
  "test_security_path_check_permissions__valid_arguments__@vary__logs_error_message" \
  "TEST_STAT_PERMISSIONS,TEST_ERROR_LOG,TEST_INFO_LOG" \
  "incorrect_permissions,755,SECURITY: The permissions on '/mnt/path1' are not secure!,Please consider running: sudo chmod 644 /mnt/path1"

test_security_path_check_permissions__valid_arguments__@vary__returns_correct_status_code() {
  stat.mock.set.stdout "${TEST_STAT_PERMISSIONS}"

  _capture.rc _security_path_check_permissions "/mnt/path1" "644"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize \
  "test_security_path_check_permissions__valid_arguments__@vary__returns_correct_status_code" \
  "TEST_STAT_PERMISSIONS,TEST_EXPECTED_RC" \
  "correct_permissions__,644,0" \
  "incorrect_permissions,755,127"
