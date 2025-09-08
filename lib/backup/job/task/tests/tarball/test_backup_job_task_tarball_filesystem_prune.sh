#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/backup/job/task/tests/tarball/__fixtures__/tarball_file_listing.sh"

setup_suite() {
  TEST_TARBALL_FOLDER="$(mktemp -d)"
}

setup() {
  _mock.create _cli_log_warning

  rm -f "${TEST_TARBALL_FOLDER}/"*
}

teardown_suite() {
  rm -r "${TEST_TARBALL_FOLDER}"
}

_fixture_populate_test_folder() {
  local filename_list=()
  local filename

  stdlib.array.make.from_string filename_list $'\n' "$(_fixture_generate_ls_output "${TEST_NUM_FILES}" "${TEST_TARBALL_FOLDER}" "${TEST_JOB_NAME}")"

  for filename in "${filename_list[@]}"; do
    touch "${filename}"
    sleep 0.01
  done
}

_map_basename() {
  # $1: the filename

  basename "${1}"
}

@parametrize_with_tarball_jobs() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "@fixture _fixture_populate_test_folder" \
    "TEST_NUM_FILES;TEST_JOB_NAME;TEST_VERSION_COUNT" \
    "6_files__3_versions;6;job1;3" \
    "3_files__1_versions;3;job2;1" \
    "3_files__3_versions;3;job3;3"
}

# shellcheck disable=SC2034
test_backup_job_task_tarball_filesystem_prune__@vary__logs_warning_message() {
  local RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS="${TEST_VERSION_COUNT}"
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER="${TEST_TARBALL_FOLDER}"
  local RPI_BACKUP_JOB_NAME="${TEST_JOB_NAME}"

  _backup_job_task_tarball_filesystem_prune

  _cli_log_warning.mock.assert_called_once_with \
    "1( -- BACKUP JOB: Restricting storage to '${TEST_VERSION_COUNT}' tarball version(s) ... )"
}

@parametrize_with_tarball_jobs \
  test_backup_job_task_tarball_filesystem_prune__@vary__logs_warning_message

# shellcheck disable=SC2034
test_backup_job_task_tarball_filesystem_prune__@vary__removes_correct_files() {
  local RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS="${TEST_VERSION_COUNT}"
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER="${TEST_TARBALL_FOLDER}"
  local RPI_BACKUP_JOB_NAME="${TEST_JOB_NAME}"
  local expected_filelist

  _backup_job_task_tarball_filesystem_prune

  stdlib.array.make.from_string expected_filelist $'\n' "$(_fixture_generate_ls_output "${TEST_NUM_FILES}" "${TEST_TARBALL_FOLDER}" "${TEST_JOB_NAME}")"
  stdlib.array.mutate.reverse expected_filelist
  expected_filelist=("${expected_filelist[@]:0:${TEST_VERSION_COUNT}}")
  assert_equals "$(stdlib.array.map.fn _map_basename expected_filelist)" "$(ls -t1 "${TEST_TARBALL_FOLDER}")"
}

@parametrize_with_tarball_jobs \
  test_backup_job_task_tarball_filesystem_prune__@vary__removes_correct_files
