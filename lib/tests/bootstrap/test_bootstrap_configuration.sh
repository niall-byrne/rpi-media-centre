#!/bin/bash

setup() {
  _mock.create _dependencies_group_cli
  _mock.create _security_root_require
  _mock.create _configuration_pictl
  _mock.create _io_colours_load

  _mock.create _configuration_pictl_validation
}

@parametrize_with_command_scenarios() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_COMMAND_ARGS_DEFINITION;TEST_EXPECTED_DISABLED_VALIDATORS" \
    "non_account_command;arg1|arg2;;" \
    "account_command____;account;'account'"
}

test_bootstrap_configuration__@vary__checks_cli_dependencies() {
  local command_args=()

  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _bootstrap_configuration "${command_args[@]}"

  _dependencies_group_cli.mock.assert_called_once_with ""
}

@parametrize_with_command_scenarios \
  test_bootstrap_configuration__@vary__checks_cli_dependencies

test_bootstrap_configuration__@vary__requires_the_root_user() {
  local command_args=()

  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _bootstrap_configuration "${command_args[@]}"

  _security_root_require.mock.assert_called_once_with ""
}

@parametrize_with_command_scenarios \
  test_bootstrap_configuration__@vary__requires_the_root_user

test_bootstrap_configuration__@vary__loads_the_pictl_configuration() {
  local command_args=()

  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _bootstrap_configuration "${command_args[@]}"

  _configuration_pictl.mock.assert_called_once_with ""
}

@parametrize_with_command_scenarios \
  test_bootstrap_configuration__@vary__loads_the_pictl_configuration

test_bootstrap_configuration__@vary__io_colours_load() {
  local command_args=()

  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _bootstrap_configuration "${command_args[@]}"

  _io_colours_load.mock.assert_called_once_with ""
}

@parametrize_with_command_scenarios \
  test_bootstrap_configuration__@vary__io_colours_load

test_bootstrap_configuration__@vary__validates_configuration_with_expected_validators() {
  local command_args=()

  _configuration_pictl_validation.mock.set.keywords "RPI_CONFIGURATION_VALIDATORS_DISABLED_ARRAY"
  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _bootstrap_configuration "${command_args[@]}"

  _configuration_pictl_validation.mock.assert_called_once_with \
    "RPI_CONFIGURATION_VALIDATORS_DISABLED_ARRAY(${TEST_EXPECTED_DISABLED_VALIDATORS})"
}

@parametrize_with_command_scenarios \
  test_bootstrap_configuration__@vary__validates_configuration_with_expected_validators
