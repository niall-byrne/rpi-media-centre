#!/bin/bash

setup() {
  _mock.create _cli_log_error
  _mock.create _backup_job_log
  _mock.create _backup_manifest_help

  _backup_job_log.mock.set.stdout "mocked_line_log"
  _backup_manifest_help.mock.set.stdout "mocked_manifest_help"
}

test_backup_manifest_line_invalid__returns_status_code_127() {
  local FILE_LINE="mock_file_line"

  _capture.rc _backup_manifest_line_invalid > /dev/null 2>&1

  assert_rc "127"
}

test_backup_manifest_line_invalid__outputs_expected_stderr() {
  local FILE_LINE="mock_file_line"

  _capture.stderr _backup_manifest_line_invalid

  assert_output "The ${RPI_MANIFEST_BACKUP} file is improperly formatted!
Input Line: ${FILE_LINE}
mocked_line_log
mocked_manifest_help"
}
