#!/bin/bash

setup() {
  _mock.create _backup_cli_service_cli_start
  _mock.create _backup_cli_service_cli_before_all
}

test_pictl_cli__integration__backup_service_start__cli_mode______shows_error_message() {
  _capture.output _pictl_cli backup service start option1 option2

  assert_snapshot "__fixtures__/backup_service_restricted.txt"
}

test_pictl_cli__integration__backup_service_start__cli_mode______does_not_call_before_all_function() {
  _capture.output _pictl_cli backup service start option1 option2

  _backup_cli_service_cli_before_all.mock.assert_not_called
}

test_pictl_cli__integration__backup_service_start__cli_mode______does_not_call_target_function() {
  _capture.output _pictl_cli backup service start option1 option2

  _backup_cli_service_cli_start.mock.assert_not_called
}

# shellcheck disable=SC2034
test_pictl_cli__integration__backup_service_start__service_mode__calls_before_all_function_correctly() {
  local RPI_RUNTIME_ENVIRONMENT="service"

  _pictl_cli backup service start

  _backup_cli_service_cli_before_all.mock.assert_called_once_with ""
}

# shellcheck disable=SC2034
test_pictl_cli__integration__backup_service_start__service_mode__calls_target_function_correctly() {
  local RPI_RUNTIME_ENVIRONMENT="service"

  _pictl_cli backup service start

  _backup_cli_service_cli_start.mock.assert_called_once_with ""
}
