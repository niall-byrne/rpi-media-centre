#!/bin/bash

setup() {
  _mock.create _backup_job
  _mock.create _backup_cli_service_cli_before_all
}

test_pictl_cli__integration__backup_service_job__cli_mode______shows_error_message() {
  _capture.output _pictl_cli backup service job option1 option2

  assert_snapshot "../__fixtures__/backup_service_restricted.txt"
}

test_pictl_cli__integration__backup_service_job__cli_mode______does_not_call_before_all_function() {
  _capture.output _pictl_cli backup service job option1 option2

  _backup_cli_service_cli_before_all.mock.assert_not_called
}

test_pictl_cli__integration__backup_service_job__cli_mode______does_not_call_target_function() {
  _capture.output _pictl_cli backup service job option1 option2

  _backup_job.mock.assert_not_called
}

# shellcheck disable=SC2034
test_pictl_cli__integration__backup_service_job__service_mode__valid_args____calls_before_all_function_correctly() {
  local RPI_RUNTIME_ENVIRONMENT="service"

  _pictl_cli backup service job option1 option2

  _backup_cli_service_cli_before_all.mock.assert_called_once_with \
    "1(option1) 2(option2)"
}

# shellcheck disable=SC2034
test_pictl_cli__integration__backup_service_job__service_mode__valid_args____calls_target_function_correctly() {
  local RPI_RUNTIME_ENVIRONMENT="service"

  _pictl_cli backup service job option1 option2

  _backup_job.mock.assert_called_once_with \
    "1(option1) 2(option2)"
}

# shellcheck disable=SC2034
test_pictl_cli__integration__backup_service_job__service_mode__invalid_args____show_error_message() {
  local RPI_RUNTIME_ENVIRONMENT="service"

  _mock.delete _backup_job

  _capture.output _pictl_cli backup service job

  assert_snapshot "__fixtures__/backup_service_job.txt"
}
