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
  _capture_logs _capture_logs _backup_manifest_line_log_all

  _cli_log_notice.mock.assert_count_is 2
  _cli_log_notice.mock.assert_calls_are \
    "1(== Start of Job '${RPI_BACKUP_JOB_NAME}' ==)" \
    "1(== End of Job '${RPI_BACKUP_JOB_NAME}' ==)"
}

test_backup_manifest_line_log_all__calls_bumpers_around_job_log_contents() {
  _mock.sequence.record.start

  _capture_logs _backup_manifest_line_log_all

  _mock.sequence.assert_is \
    "_cli_log_notice" \
    "_backup_job_log" \
    "_cli_log_notice"
}
