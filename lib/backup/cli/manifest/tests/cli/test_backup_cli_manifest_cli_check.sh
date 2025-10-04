#!/bin/bash

setup() {
  _mock.create _backup_manifest_command_all
  _mock.create _cli_log_success
}

test_backup_cli_manifest_cli_check__checks_the_manifest() {
  _backup_cli_manifest_cli_check

  _backup_manifest_command_all.mock.assert_called_once_with \
    "1(_backup_manifest_line_log_all)"
}

# shellcheck disable=SC2034
test_backup_cli_manifest_cli_check__ensures_all_validators_are_run() {
  local RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY=("mock_disabled_validator")

  _backup_manifest_command_all.mock.set.keywords "RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY"

  _backup_cli_manifest_cli_check

  _backup_manifest_command_all.mock.assert_called_once_with \
    "1(_backup_manifest_line_log_all) RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY()"
}

test_backup_cli_manifest_cli_check__logs_success_message() {
  _backup_cli_manifest_cli_check

  _cli_log_success.mock.assert_called_once_with \
    "1(The rpi-media-centre backup manifest file is valid!)"
}
