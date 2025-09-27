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

# shellcheck disable=SC2034
test_manifest_cli_check_backup__ensures_all_validators_are_run() {
  local RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY=("mock_disabled_validator")

  _backup_manifest_all_command.mock.set.keywords "RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY"

  _manifest_cli_check_backup

  _backup_manifest_all_command.mock.assert_called_once_with \
    "1(_backup_manifest_line_log_all) RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY()"
}

test_manifest_cli_check_backup__logs_success_message() {
  _manifest_cli_check_backup

  _cli_log_success.mock.assert_called_once_with \
    "1(The rpi-media-centre backup manifest file is valid!)"
}
