#!/bin/bash

setup() {
  _mock.create _dependencies_group_cli
  _mock.create _security_root_require
  _mock.create _configuration_pictl
  _mock.create _io_colours_load
  _mock.create _security_validate

  _mock.create _security_defaults_set
  _mock.create _security_warning_single_user_mode
}

@parametrize_with_command_scenarios() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_COMMAND_ARGS_DEFINITION" \
    "non_account_command;arg1|arg2;" \
    "account_command____;account"
}

test_bootstrap_configuration_and_security__@vary__checks_cli_dependencies() {
  local command_args=()

  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _bootstrap_configuration_and_security "${command_args[@]}"

  _dependencies_group_cli.mock.assert_called_once_with ""
}

@parametrize_with_command_scenarios \
  test_bootstrap_configuration_and_security__@vary__checks_cli_dependencies

test_bootstrap_configuration_and_security__@vary__requires_the_root_user() {
  local command_args=()

  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _bootstrap_configuration_and_security "${command_args[@]}"

  _security_root_require.mock.assert_called_once_with ""
}

@parametrize_with_command_scenarios \
  test_bootstrap_configuration_and_security__@vary__requires_the_root_user

test_bootstrap_configuration_and_security__@vary__loads_the_pictl_configuration() {
  local command_args=()

  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _bootstrap_configuration_and_security "${command_args[@]}"

  _configuration_pictl.mock.assert_called_once_with ""
}

@parametrize_with_command_scenarios \
  test_bootstrap_configuration_and_security__@vary__loads_the_pictl_configuration

test_bootstrap_configuration_and_security__@vary__io_colours_load() {
  local command_args=()

  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _bootstrap_configuration_and_security "${command_args[@]}"

  _io_colours_load.mock.assert_called_once_with ""
}

@parametrize_with_command_scenarios \
  test_bootstrap_configuration_and_security__@vary__io_colours_load

test_bootstrap_configuration_and_security__@vary__validates_pictl_settings_for_security() {
  local command_args=()

  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _bootstrap_configuration_and_security "${command_args[@]}"

  _security_validate.mock.assert_called_once_with ""
}

@parametrize_with_command_scenarios \
  test_bootstrap_configuration_and_security__@vary__validates_pictl_settings_for_security

test_bootstrap_configuration_and_security__non_account_command__loads_the_security_defaults() {
  _bootstrap_configuration_and_security "arg1" "arg2"

  _security_defaults_set.mock.assert_called_once_with ""
}

test_bootstrap_configuration_and_security__account_command______loads_the_security_defaults() {
  _bootstrap_configuration_and_security "account"

  _security_defaults_set.mock.assert_not_called
}

test_bootstrap_configuration_and_security__non_account_command__calls_single_user_mode_warning() {
  _bootstrap_configuration_and_security "arg1" "arg2"

  _security_warning_single_user_mode.mock.assert_called_once_with ""
}

test_bootstrap_configuration_and_security__account_command______does_not_call_single_user_mode_warning() {
  _bootstrap_configuration_and_security "account"

  _security_warning_single_user_mode.mock.assert_not_called
}
