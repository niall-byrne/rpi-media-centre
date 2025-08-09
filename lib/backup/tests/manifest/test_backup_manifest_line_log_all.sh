#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/backup/tests/__fakes__/backup_data.sh"

setup() {
  _mock.create _backup_job_log
  fake_backup_job_n 1
}

test_backup_manifest_line_log_all__calls_backup_job_log() {
  _capture_logs _backup_manifest_line_log_all

  _backup_job_log.mock.assert_called_once_with ""
}

test_backup_manifest_line_log_all__calls_logging_bumper_messages() {
  _capture_logs _backup_manifest_line_log_all

  assert_equals "2" "$(_cli_log_notice.mock.get.count)"
  assert_equals \
    "== Start of Job '${RPI_BACKUP_JOB_NAME}' ==" \
    "$(_cli_log_notice.mock.get.call "1")"
  assert_equals \
    "== End of Job '${RPI_BACKUP_JOB_NAME}' ==" \
    "$(_cli_log_notice.mock.get.call "2")"
}

test_backup_manifest_line_log_all__calls_commands_in_required_sequence() {
  _capture_logs _backup_manifest_line_log_all

  _mock.sequence.assert_is "_cli_log_notice" "_backup_job_log" "_cli_log_notice"
}
