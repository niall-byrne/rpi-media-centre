#!/bin/bash

load "${RPI_WORKING_DIRECTORY}/lib/backup/tests/__fakes__/backup_data.sh"

setup() {
  _mock.create _backup_manifest_load
  _mock.create mocked_backup_manifest_all_command
}

@parametrize_with_fake_manifests() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "@fixture _backup_manifest_load.mock.set.subcommand 'fake_manifest_n_entries \${MANIFEST_ENTRIES} \${FAKE_MANIFEST_GROUP_START_INDEX} \${FAKE_MANIFEST_GROUP_LIMIT}' " \
    "MANIFEST_ENTRIES,MANIFEST_COMMAND_CALL_COUNT,FAKE_MANIFEST_START_INDEX,FAKE_MANIFEST_GROUP_START_INDEX,FAKE_MANIFEST_GROUP_LIMIT,MANIFEST_GROUP_FILTER,MANIFEST_JOB_FILTER" \
    "2_manifest_entries,2,2,0,0,0,,," \
    "3_manifest_entries,3,3,0,0,0,,," \
    "3_manifest_entries__filtered_by_group,3,1,2,2,2,job_group2,," \
    "3_manifest_entries__filtered_by_job,3,1,2,2,2,,job_name2"
}

test_backup_manifest_all_command__loads_manifest() {
  _backup_manifest_all_command mocked_backup_manifest_all_command "${MANIFEST_GROUP_FILTER}" "${MANIFEST_JOB_FILTER}"

  _backup_manifest_load.mock.assert_called_once_with ""
}

test_backup_manifest_all_command__@vary__return_code_0() {
  _capture_rc _backup_manifest_all_command mocked_backup_manifest_all_command "${MANIFEST_GROUP_FILTER}" "${MANIFEST_JOB_FILTER}"

  assert_rc "0"
}

@parametrize_with_fake_manifests \
  test_backup_manifest_all_command__@vary__return_code_0

test_backup_manifest_all_command__@vary__calls_mocked_backup_all_command() {
  _backup_manifest_all_command mocked_backup_manifest_all_command "${MANIFEST_GROUP_FILTER}" "${MANIFEST_JOB_FILTER}"

  mocked_backup_manifest_all_command.mock.assert_count_is "${MANIFEST_COMMAND_CALL_COUNT}"
}

@parametrize_with_fake_manifests \
  test_backup_manifest_all_command__@vary__calls_mocked_backup_all_command

test_backup_manifest_all_command__@vary__sets_environment() {
  TEST_EXPECTED="$(
    _create_fake_job_n_log_entries \
      "${MANIFEST_COMMAND_CALL_COUNT}" \
      "${FAKE_MANIFEST_START_INDEX}" \
      "${FAKE_MANIFEST_GROUP_START_INDEX}" \
      "${FAKE_MANIFEST_GROUP_LIMIT}"
  )"

  _capture_stdout _backup_manifest_all_command _backup_job_log "${MANIFEST_GROUP_FILTER}" "${MANIFEST_JOB_FILTER}"

  assert_output "${TEST_EXPECTED}"
}

@parametrize_with_fake_manifests \
  test_backup_manifest_all_command__@vary__sets_environment
