#!/bin/bash

setup() {
  _mock.create _backup_manifest_all_command
  _mock.create _cli_log_success
}

test_manifest_cli_check_backup__checks_the_manifest() {
  _manifest_cli_check_backup

  _backup_manifest_all_command.mock.assert_called_once_with \
    "1(_backup_manifest_line_log_all)"
}

test_manifest_cli_check_backup__logs_success_message() {
  _manifest_cli_check_backup

  _cli_log_success.mock.assert_called_once_with \
    "1(The rpi-media-centre backup manifest file is valid!)"
}
