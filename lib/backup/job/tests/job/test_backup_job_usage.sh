#!/bin/bash

setup() {
  _mock.create _backup_job_cli_usage
  _mock.create _backup_job_message_tarball_versions
  _mock.create _backup_job_message_remote_target
  _mock.create _backup_job_message_remote_param
  _mock.create _backup_job_message_queue
}

test_backup_job_usage__calls_dependencies_in_correct_sequence() {
  _mock.sequence.record.start

  _backup_job_usage 2> /dev/null

  _mock.sequence.assert_is \
    "_backup_job_cli_usage" \
    "_backup_job_message_tarball_versions" \
    "_backup_job_message_remote_target" \
    "_backup_job_message_remote_param" \
    "_backup_job_message_queue"
}

test_backup_job_usage__redirects_stdout_to_stderr() {
  _backup_job_cli_usage.mock.set.stdout "cli_usage"
  _backup_job_message_tarball_versions.mock.set.stdout "tarball_versions"
  _backup_job_message_remote_target.mock.set.stdout "remote_target"
  _backup_job_message_remote_param.mock.set.stdout "remote_param"
  _backup_job_message_queue.mock.set.stdout "queue"

  _capture.stderr _backup_job_usage

  assert_output "cli_usage
tarball_versions
remote_target
remote_param
queue" "${TEST_OUTPUT}"
}

test_backup_job_usage__produces_no_stdout() {
  _backup_job_cli_usage.mock.set.stdout "cli_usage"

  _capture.stdout _backup_job_usage

  assert_output_null
}

test_backup_job_usage__returns_correct_exit_code() {
  _capture.rc _backup_job_usage

  assert_rc "127"
}
