#!/bin/bash

test_pictl_cli__integration__backup_service__cli_mode______no_command____shows_error_message() {
  _mock.create _cli_logger_error

  _capture.output _pictl_cli backup service

  assert_snapshot "__fixtures__/backup_service_restricted.txt"
}

test_pictl_cli__integration__backup_service__cli_mode______help_command__shows_error_message() {
  _mock.create _cli_logger_error

  _capture.output _pictl_cli backup service

  assert_snapshot "__fixtures__/backup_service_restricted.txt"
}

# shellcheck disable=SC2034
test_pictl_cli__integration__backup_service__service_mode__no_command____shows_correct_menu() {
  local RPI_RUNTIME_ENVIRONMENT="service"

  _capture.output _pictl_cli backup service

  assert_snapshot "__fixtures__/backup_service.txt"
}

# shellcheck disable=SC2034
test_pictl_cli__integration__backup_service__service_mode__no_command____return_code_127() {
  local RPI_RUNTIME_ENVIRONMENT="service"

  _capture.rc _pictl_cli backup service > /dev/null

  assert_rc "127"
}

# shellcheck disable=SC2034
test_pictl_cli__integration__backup_service__service_mode__help_command__shows_correct_menu() {
  local RPI_RUNTIME_ENVIRONMENT="service"

  _capture.output _pictl_cli backup service help

  assert_snapshot "__fixtures__/backup_service.txt"
}

# shellcheck disable=SC2034
test_pictl_cli__integration__backup_service__service_mode__help_command__return_code_0() {
  local RPI_RUNTIME_ENVIRONMENT="service"

  _capture.rc _pictl_cli backup service help > /dev/null

  assert_rc "0"
}
