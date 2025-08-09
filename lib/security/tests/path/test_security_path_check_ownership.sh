#!/bin/bash

setup() {
  _fixture_mock_logs

  _mock.create _io_ensure_vars_set
  _mock.create _security_id_get_uid
  _mock.create _security_id_get_gid
  _mock.create stat

  _security_id_get_uid.mock.set.stdout "1001"
  _security_id_get_gid.mock.set.stdout "1002"
}

test_security_path_check_ownership__@vary__calls_io_ensure_vars_set() {
  _array_from_string TEST_ARGUMENTS "|" "${TEST_ARGUMENT_DEFINITION}"

  _security_path_check_ownership "${TEST_ARGUMENTS[@]}"

  _io_ensure_vars_set.mock.assert_called_once_with "3 ${EXPECTED_ARGS}"
}

@parametrize \
  "test_security_path_check_ownership__@vary__calls_io_ensure_vars_set" \
  "TEST_ARGUMENT_DEFINITION,EXPECTED_ARGS" \
  "valid_arguments,/mnt/path1|user1|group1,/mnt/path1 user1 group1" \
  "omitted_user___,/mnt/path1||group1,/mnt/path1  group1" \
  "unset_group____,/mnt/path1|user1|,/mnt/path1 user1"

test_security_path_check_ownership__valid_argument__calls_security_id_get_uid() {
  _security_path_check_ownership "/mnt/path1" "MOCK_USERNAME" "MOCK_GROUP"

  _security_id_get_uid.mock.assert_called_once_with "MOCK_USERNAME"
}

test_security_path_check_ownership__valid_argument__calls_security_id_get_gid() {
  _security_path_check_ownership "/mnt/path1" "MOCK_USERNAME" "MOCK_GROUP"

  _security_id_get_gid.mock.assert_called_once_with "MOCK_GROUP"
}

test_security_path_check_ownership__valid_arguments__@vary__calls_stat() {
  stat.mock.set.side_effects "echo ${TEST_STAT_UID}" "echo ${TEST_STAT_GID}"

  _security_path_check_ownership "/mnt/path1" "MOCK_USERNAME" "MOCK_GROUP"

  assert_equals "${TEST_EXPECTED_CALLS}" "$(stat.mock.get.count)"
  assert_equals "${TEST_CALL_1_ARGS}" "$(stat.mock.get.call "1")"
  assert_equals "${TEST_CALL_2_ARGS}" "$(stat.mock.get.call "2")"
}

@parametrize \
  "test_security_path_check_ownership__valid_arguments__@vary__calls_stat" \
  "TEST_EXPECTED_CALLS,TEST_STAT_UID,TEST_STAT_GID,TEST_CALL_1_ARGS,TEST_CALL_2_ARGS" \
  "correct_uid____correct_gid____,2,1001,1002,-c %u /mnt/path1,-c %g /mnt/path1" \
  "correct_uid____incorrect_gid__,2,1001,999,-c %u /mnt/path1,-c %g /mnt/path1" \
  "incorrect_uid__correct_gid____,1,999,1002,-c %u /mnt/path1,," \
  "incorrect_uid__incorrect_gid__,1,999,999,-c %u /mnt/path1,,"

test_security_path_check_ownership__valid_arguments__@vary__logs_error_message() {
  stat.mock.set.side_effects "echo ${TEST_STAT_UID}" "echo ${TEST_STAT_GID}"

  _security_path_check_ownership "/mnt/path1" "MOCK_USERNAME" "MOCK_GROUP"

  _cli_log_error.mock.assert_called_once_with "${TEST_ERROR_LOG}"
  _cli_log_info.mock.assert_called_once_with "${TEST_INFO_LOG}"
}

@parametrize \
  "test_security_path_check_ownership__valid_arguments__@vary__logs_error_message" \
  "TEST_STAT_UID,TEST_STAT_GID,TEST_ERROR_LOG,TEST_INFO_LOG" \
  "correct_uid____incorrect_gid__,1001,999,SECURITY: The permissions on '/mnt/path1' are not secure!,Please consider running: sudo chgrp MOCK_GROUP /mnt/path1" \
  "incorrect_uid__correct_gid____,999,1002,SECURITY: The permissions on '/mnt/path1' are not secure!,Please consider running: sudo chown MOCK_USERNAME:MOCK_GROUP /mnt/path1" \
  "incorrect_uid__incorrect_gid__,999,999,SECURITY: The permissions on '/mnt/path1' are not secure!,Please consider running: sudo chown MOCK_USERNAME:MOCK_GROUP /mnt/path1"

test_security_path_check_ownership__valid_arguments__@vary__return_code_is_correct() {
  stat.mock.set.side_effects "echo ${TEST_STAT_UID}" "echo ${TEST_STAT_GID}"

  _capture.rc _security_path_check_ownership "/mnt/path1" "MOCK_USERNAME" "MOCK_GROUP"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize \
  "test_security_path_check_ownership__valid_arguments__@vary__return_code_is_correct" \
  "TEST_STAT_UID,TEST_STAT_GID,TEST_EXPECTED_RC" \
  "correct_uid____correct_gid____,1001,1002,0" \
  "correct_uid____incorrect_gid__,1001,999,127" \
  "incorrect_uid__correct_gid____,999,1002,127" \
  "incorrect_uid__incorrect_gid__,999,999,127"
