#!/bin/bash

setup() {
  _mock.create _cli_log_warning
  _mock.create _cli_log_success
  _mock.create aws
  _mock.create stdlib.security.path.secure
}

@parametrize_with_unencrypted_scenarios() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_JOB_NAME;TEST_REMOTE_TARGET;TEST_RECOVERY_PATH;TEST_USERNAME;TEST_GROUPNAME;TEST_CONNECT_TIMEOUT;TEST_READ_TIMEOUT" \
    "unencrypted_scenario1;job1;s3://bucket1;/tmp/rec1;user1;group1;121;122" \
    "unencrypted_scenario2;job2;s3://bucket2;/tmp/rec2;user2;group2;98;99"
}

@parametrize_with_encrypted_scenarios() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_JOB_NAME;TEST_REMOTE_TARGET;TEST_RECOVERY_PATH;TEST_ENCRYPTION_KEY;TEST_USERNAME;TEST_GROUPNAME;TEST_CONNECT_TIMEOUT;TEST_READ_TIMEOUT" \
    "encrypted_scenario1;job1;s3://bucket1;/tmp/rec1;/path/to/key1;user1;group1;121;122" \
    "encrypted_scenario2;job2;s3://bucket2;/tmp/rec2;/path/to/key2;user2;group2;98;99"
}

# shellcheck disable=SC2034
test_backup_job_task_recover_s3__@vary__@vary__calls_log_warning() {
  local RPI_BACKUP_JOB_NAME="${TEST_JOB_NAME}"
  local RPI_SVC_USERNAME="${TEST_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_GROUPNAME}"

  _backup_job_task_recover_s3

  _cli_log_warning.mock.assert_called_once_with \
    "1(Starting data recovery for job '${TEST_JOB_NAME}' ...)"
}

@parametrize.apply \
  test_backup_job_task_recover_s3__@vary__@vary__calls_log_warning \
  @parametrize_with_unencrypted_scenarios \
  @parametrize_with_encrypted_scenarios

# shellcheck disable=SC2034
test_backup_job_task_recover_s3__unencrypted_scenarios__@vary__calls_aws_s3_cp_with_correct_args() {
  local RPI_BACKUP_JOB_NAME="${TEST_JOB_NAME}"
  local RPI_BACKUP_JOB_REMOTE_TARGET="${TEST_REMOTE_TARGET}"
  local RPI_BACKUP_JOB_RECOVERY_PATH="${TEST_RECOVERY_PATH}"
  local RPI_BACKUP_S3_REMOTE_TIMEOUT_CONNECT="${TEST_CONNECT_TIMEOUT}"
  local RPI_BACKUP_S3_REMOTE_TIMEOUT_READ="${TEST_READ_TIMEOUT}"
  local RPI_SVC_USERNAME="${TEST_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_GROUPNAME}"

  _backup_job_task_recover_s3

  aws.mock.assert_called_once_with \
    "1(--cli-connect-timeout) 2(${TEST_CONNECT_TIMEOUT}) 3(--cli-read-timeout) 4(${TEST_READ_TIMEOUT}) 5(s3) 6(cp) 7(${TEST_REMOTE_TARGET}/${TEST_JOB_NAME}.tar) 8(${TEST_RECOVERY_PATH}/${TEST_JOB_NAME}-recovered.tar)"
}

@parametrize_with_unencrypted_scenarios \
  test_backup_job_task_recover_s3__unencrypted_scenarios__@vary__calls_aws_s3_cp_with_correct_args

# shellcheck disable=SC2034
test_backup_job_task_recover_s3__encrypted_scenarios____@vary__calls_aws_s3_cp_with_correct_args() {
  local RPI_BACKUP_JOB_NAME="${TEST_JOB_NAME}"
  local RPI_BACKUP_JOB_REMOTE_TARGET="${TEST_REMOTE_TARGET}"
  local RPI_BACKUP_JOB_RECOVERY_PATH="${TEST_RECOVERY_PATH}"
  local RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH="${TEST_ENCRYPTION_KEY}"
  local RPI_BACKUP_S3_REMOTE_TIMEOUT_CONNECT="${TEST_CONNECT_TIMEOUT}"
  local RPI_BACKUP_S3_REMOTE_TIMEOUT_READ="${TEST_READ_TIMEOUT}"
  local RPI_SVC_USERNAME="${TEST_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_GROUPNAME}"

  _backup_job_task_recover_s3

  aws.mock.assert_called_once_with \
    "1(--cli-connect-timeout) 2(${TEST_CONNECT_TIMEOUT}) 3(--cli-read-timeout) 4(${TEST_READ_TIMEOUT}) 5(s3) 6(cp) 7(${TEST_REMOTE_TARGET}/${TEST_JOB_NAME}.tar) 8(${TEST_RECOVERY_PATH}/${TEST_JOB_NAME}-recovered.tar) 9(--sse-c) 10(AES256) 11(--sse-c-key) 12(fileb://${TEST_ENCRYPTION_KEY})"
}

@parametrize_with_encrypted_scenarios \
  test_backup_job_task_recover_s3__encrypted_scenarios____@vary__calls_aws_s3_cp_with_correct_args

test_backup_job_task_recover_s3__@vary__@vary__calls_path_secure() {
  local RPI_BACKUP_JOB_NAME="${TEST_JOB_NAME}"
  local RPI_BACKUP_JOB_RECOVERY_PATH="${TEST_RECOVERY_PATH}"
  local RPI_SVC_USERNAME="${TEST_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_GROUPNAME}"
  local recovered_filename="${RPI_BACKUP_JOB_RECOVERY_PATH}/${RPI_BACKUP_JOB_NAME}-recovered.tar"

  _backup_job_task_recover_s3

  stdlib.security.path.secure.mock.assert_called_once_with \
    "1(${recovered_filename}) 2(${TEST_USERNAME}) 3(${TEST_GROUPNAME}) 4(600)"
}

@parametrize.apply \
  test_backup_job_task_recover_s3__@vary__@vary__calls_path_secure \
  @parametrize_with_unencrypted_scenarios \
  @parametrize_with_encrypted_scenarios

# shellcheck disable=SC2034
test_backup_job_task_recover_s3__@vary__@vary__calls_log_success() {
  local RPI_BACKUP_JOB_NAME="${TEST_JOB_NAME}"
  local RPI_SVC_USERNAME="${TEST_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_GROUPNAME}"

  _backup_job_task_recover_s3

  _cli_log_success.mock.assert_called_once_with \
    "1(Data recovery for job '${RPI_BACKUP_JOB_NAME}' was successful !)"
}

@parametrize.apply \
  test_backup_job_task_recover_s3__@vary__@vary__calls_log_success \
  @parametrize_with_unencrypted_scenarios \
  @parametrize_with_encrypted_scenarios
