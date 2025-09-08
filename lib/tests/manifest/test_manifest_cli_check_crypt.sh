#!/bin/bash

setup() {
  _mock.create _disk_manifest_all_command
  _mock.create _cli_log_success
}

test_manifest_cli_check_crypt__checks_the_manifest() {
  _manifest_cli_check_crypt

  _disk_manifest_all_command.mock.assert_called_once_with \
    "1(_disk_manifest_line_log_all)"
}

test_manifest_cli_check_crypt__logs_success_message() {
  _manifest_cli_check_crypt

  _cli_log_success.mock.assert_called_once_with \
    "1(The rpi-media-centre crypt manifest file is valid!)"
}
