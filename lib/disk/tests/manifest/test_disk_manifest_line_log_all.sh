#!/bin/bash

load "${RPI_WORKING_DIRECTORY}/lib/disk/tests/__fakes__/crypt_data.sh"

setup() {
  _mock.create _disk_manifest_line_log
  fake_disk_1
}

test_disk_manifest_line_log_all__calls_disk_manifest_line_log() {
  _capture_logs _disk_manifest_line_log_all

  _disk_manifest_line_log.mock.assert_called_once_with ""
}

test_disk_manifest_line_log_all__calls_logging_bumper_messages() {
  _capture_logs _disk_manifest_line_log_all

  assert_equals "2" "$(_cli_log_notice.mock.get.count)"
  assert_equals \
    "== Start of Disk '${TEST_MOCK_DISK_NAME_1}' ==" \
    "$(_cli_log_notice.mock.get.call "1")"
  assert_equals \
    "== End of Disk '${TEST_MOCK_DISK_NAME_1}' ==" \
    "$(_cli_log_notice.mock.get.call "2")"
}

test_disk_manifest_line_log_all__calls_commands_in_required_sequence() {
  _capture_logs _disk_manifest_line_log_all

  _mock.sequence.assert_is "_cli_log_notice" "_disk_manifest_line_log" "_cli_log_notice"
}
