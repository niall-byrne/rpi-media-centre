#!/bin/bash

setup() {
  _mock.create _cli_log_error
}

@parametrize_with_scenarios() {
  # $1: the test to parametrize

  @parametrize \
    "${1}" \
    "TEST_ENV;TEST_SHOULD_LOG;TEST_RC" \
    "not_service;dev;true;127" \
    "is_service;service;false;0"
}

test_backup_cli_service_cli_restricted__@vary__returns_correct_exit_code() {
  # shellcheck disable=SC2034
  local RPI_RUNTIME_ENVIRONMENT="${TEST_ENV}"

  _capture.rc _backup_cli_service_cli_--restricted--

  assert_rc "${TEST_RC}"
}

@parametrize_with_scenarios \
  test_backup_cli_service_cli_restricted__@vary__returns_correct_exit_code

test_backup_cli_service_cli_restricted__not_service__logs_error_message() {
  # shellcheck disable=SC2034
  local RPI_RUNTIME_ENVIRONMENT="dev"

  _backup_cli_service_cli_--restricted--

  _cli_log_error.mock.assert_called_once_with \
    "1(This command is restricted to the systemd backup service !)"
}

test_backup_cli_service_cli_restricted__is_service___does_not_log_error_message() {
  # shellcheck disable=SC2034
  local RPI_RUNTIME_ENVIRONMENT="service"

  _backup_cli_service_cli_--restricted--

  _cli_log_error.mock.assert_not_called
}
