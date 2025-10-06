#!/bin/bash

setup() {
  _mock.create _bootstrap_configuration
  _mock.create _cli_compiler_build_cli
  _mock.create _pictl_cli

  _pictl_cli.mock.set.keywords "_SERVICE_REMOVE_CONTAINERS"
}

@parametrize_with_args() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_COMMAND_ARGS_DEFINITION" \
    "0_arguments______;;" \
    "1_argument_______;arg1" \
    "2_arguments______;arg1|arg2"
}

test_bootstrap__@vary__passes_args_to_bootstrap_configuration_correctly() {
  local command_args=()

  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _bootstrap "${command_args[@]}"

  _bootstrap_configuration.mock.assert_called_once_with \
    "$(_mock.arg_string.from_array command_args)"
}

@parametrize_with_args \
  test_bootstrap__@vary__passes_args_to_bootstrap_configuration_correctly

test_bootstrap__@vary__calls_cli_compiler_build_cli_correctly() {
  local command_args=()

  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _bootstrap "${command_args[@]}"

  _cli_compiler_build_cli.mock.assert_called_once_with ""
}

@parametrize_with_args \
  test_bootstrap__@vary__calls_cli_compiler_build_cli_correctly

# shellcheck disable=SC2034
test_bootstrap__@vary__pass_args_to_the_pictl_cli() {
  local _SERVICE_REMOVE_CONTAINERS=0
  local command_args=()
  local keyword_args=("_SERVICE_REMOVE_CONTAINERS")

  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _bootstrap "${command_args[@]}"

  _pictl_cli.mock.assert_called_once_with \
    "$(_mock.arg_string.from_array command_args keyword_args)"
}

@parametrize_with_args \
  test_bootstrap__@vary__pass_args_to_the_pictl_cli

# shellcheck disable=SC2034
test_bootstrap__@vary__calls_dependencies_in_the_correct_sequence() {
  local command_args=()

  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"
  _mock.sequence.record.start

  _bootstrap "${command_args[@]}"

  _mock.sequence.assert_is \
    "_bootstrap_configuration" \
    "_cli_compiler_build_cli" \
    "_pictl_cli"
}

@parametrize_with_args \
  test_bootstrap__@vary__calls_dependencies_in_the_correct_sequence
