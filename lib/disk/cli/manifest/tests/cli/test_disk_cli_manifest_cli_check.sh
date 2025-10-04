#!/bin/bash

setup() {
  _mock.create _disk_manifest_command_all
  _mock.create _cli_log_success
}

test_disk_cli_manifest_cli_check__checks_the_manifest() {
  _disk_cli_manifest_cli_check

  _disk_manifest_command_all.mock.assert_called_once_with \
    "1(_disk_manifest_line_log_all)"
}

test_disk_cli_manifest_cli_check__logs_success_message() {
  _disk_cli_manifest_cli_check

  _cli_log_success.mock.assert_called_once_with \
    "1(The rpi-media-centre crypt manifest file is valid!)"
}
