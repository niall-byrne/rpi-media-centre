#!/bin/bash

load "${RPI_WORKING_DIRECTORY}/lib/backup/tests/__fakes__/backup_data.sh"
load "${RPI_WORKING_DIRECTORY}/lib/backup/tests/__fixtures__/queue.sh"

setup_suite() {
  _fixture_mock_backup_queues
  # shellcheck disable=SC2034
  RPI_BACKUP_PATH_QUEUE_ROOT="${_TEST_PATH_QUEUE_ROOT}"
  # shellcheck disable=SC2034
  RPI_BACKUP_QUEUE_NAMES=("test1" "test2")
}

teardown_suite() {
  _cleanup_mock_backup_queues
}

setup() {
  _fixture_mock_logs
  _mock.create _backup_job_args
  _mock.create _security_path_secure
}

teardown() {
  _cleanup_mock_backup_jobs
}

_fixture_generate_job_args() {
  # $1: an optional quote char

  echo "
-n ${1}${RPI_BACKUP_JOB_NAME}${1}
 -s ${1}${RPI_BACKUP_JOB_LOCAL_SOURCE}${1}
 -r ${1}${RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER}${1}
 -b ${1}${RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER}${1}
 -v ${1}${RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS}${1}
 -k ${1}${RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH}${1}
 -t ${1}${RPI_BACKUP_JOB_REMOTE_TARGET}${1}
 -p ${1}${RPI_BACKUP_JOB_REMOTE_PARAMETER}${1}" | tr -d $'\n'
}

test_backup_manifest_write_jobs_all__calls_backup_job_args_to_verify_data() {
  fake_backup_job_n "0"

  _backup_manifest_write_jobs_all

  _backup_job_args.mock.assert_count_is "1"
  _backup_job_args.mock.assert_call_n_is "1" \
    "$(_fixture_generate_job_args '') -q ${RPI_BACKUP_QUEUE_NAMES[0]}"
}

test_backup_manifest_write_jobs_all__writes_a_job_file_to_the_first_queue() {
  fake_backup_job_n "0"

  _backup_manifest_write_jobs_all

  assert_equals \
    "${RPI_BACKUP_JOB_NAME}" \
    "$(ls "${RPI_BACKUP_PATH_QUEUE_ROOT}/${RPI_BACKUP_QUEUE_NAMES[0]}")"
}

test_backup_manifest_write_jobs_all__the_file_contains_the_job_args() {
  fake_backup_job_n "0"
  TEST_EXPECTED="#!/bin/bash"$'\n'"pictl backup service job  $(_fixture_generate_job_args '"')   -q \"\${1}\""

  _backup_manifest_write_jobs_all

  assert_equals \
    "${TEST_EXPECTED}" \
    "$(cat "${RPI_BACKUP_PATH_QUEUE_ROOT}/${RPI_BACKUP_QUEUE_NAMES[0]}/${RPI_BACKUP_JOB_NAME}")"
}

test_backup_manifest_write_jobs_all__secures_the_new_job_file() {
  fake_backup_job_n "0"

  _backup_manifest_write_jobs_all

  _security_path_secure.mock.assert_called_once_with \
    "${RPI_BACKUP_PATH_QUEUE_ROOT}/${RPI_BACKUP_QUEUE_NAMES[0]}/${RPI_BACKUP_JOB_NAME} root root 700"
}
