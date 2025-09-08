#!/bin/bash

# shellcheck disable=SC2034
setup_suite() {
  test_path_compiled_root="$(mktemp -d)"
  test_path_compiled_content="${test_path_compiled_root}/cli.sh"
}

teardown_suite() {
  rm -r "${test_path_compiled_root}"
}

setup() {
  _mock.create date
  _mock.create _cli_log_warning
  _mock.create _cli_log_success

  date.mock.set.stdout "Mon Sep 15 19:53:34 UTC 2025"
}

@parametrize_with_compiler_integration_scenarios() {
  # $1: the test to parametrize

  @parametrize \
    "${1}" \
    "TEST_SCENARIO_NAME;TEST_COMPILE_MENUS_DEFINITION;TEST_EXPECTED_FUNCTION_LIST_DEFINITION" \
    "scenario1;scenario1;test|command3;_test_cli_usage|_test_cli_usage_error|_test_cli|_command3_cli_usage|_command3_cli_usage_error|_command3_cli" \
    "scenario2;scenario2;test_with_switches;_test_with_switches_cli_usage|_test_with_switches_cli_usage_error|_test_with_switches_cli"
}

@parametrize_with_mode_options() {
  # $1: the test to parametrize

  @parametrize \
    "${1}" \
    "TEST_MEMORY_MODE_BOOLEAN" \
    "file_mode__;0" \
    "memory_mode;1"
}

# shellcheck disable=SC2034
test_cli_compiler__@vary__file_mode____generates_expected_cli_content() {
  local RPI_CLI_MEMORY_ONLY_BOOLEAN=0
  local RPI_PATH_COMPILED_ROOT="${test_path_compiled_root}"
  local RPI_PATH_COMPILED_CLI="${test_path_compiled_content}"
  local RPI_PATH_COMPILED_CLI_SOURCE="${RPI_WORKING_DIRECTORY}/lib/cli/compiler/tests/__fixtures__/${TEST_SCENARIO_NAME}_cli_configuration.txt"

  _cli_compiler_cli > /dev/null 2>&1

  TEST_OUTPUT="$(cat "${test_path_compiled_content}")"
  assert_snapshot "${RPI_WORKING_DIRECTORY}/lib/cli/compiler/tests/__fixtures__/${TEST_SCENARIO_NAME}_compiled_cli_snapshot.sh"
}

@parametrize_with_compiler_integration_scenarios \
  test_cli_compiler__@vary__file_mode____generates_expected_cli_content

# shellcheck disable=SC2034
test_cli_compiler__@vary__memory_mode__does_not_populate_file() {
  local RPI_CLI_MEMORY_ONLY_BOOLEAN=1
  local RPI_PATH_COMPILED_ROOT="${test_path_compiled_root}"
  local RPI_PATH_COMPILED_CLI="${test_path_compiled_content}"
  local RPI_PATH_COMPILED_CLI_SOURCE="${RPI_WORKING_DIRECTORY}/lib/cli/compiler/tests/__fixtures__/${TEST_SCENARIO_NAME}_cli_configuration.txt"

  echo -n "" > "${test_path_compiled_content}"

  _cli_compiler_cli > /dev/null 2>&1

  assert_null "$(cat "${test_path_compiled_content}")"
}

@parametrize_with_compiler_integration_scenarios \
  test_cli_compiler__@vary__memory_mode__does_not_populate_file

# shellcheck disable=SC2034
test_cli_compiler__@vary__memory_mode__generates_all_expected_functions() {
  local RPI_CLI_MEMORY_ONLY_BOOLEAN=1
  local RPI_PATH_COMPILED_ROOT="${test_path_compiled_root}"
  local RPI_PATH_COMPILED_CLI="${test_path_compiled_content}"
  local RPI_PATH_COMPILED_CLI_SOURCE="${RPI_WORKING_DIRECTORY}/lib/cli/compiler/tests/__fixtures__/${TEST_SCENARIO_NAME}_cli_configuration.txt"
  local function_name_list=()
  local function_name

  stdlib.array.make.from_string function_name_list "|" "${TEST_EXPECTED_FUNCTION_LIST_DEFINITION}"

  _cli_compiler_cli > /dev/null 2>&1

  for function_name in "${function_name_list[@]}"; do
    assert_is_fn "${function_name}"
  done
}

@parametrize_with_compiler_integration_scenarios \
  test_cli_compiler__@vary__memory_mode__generates_all_expected_functions

# shellcheck disable=SC2034
test_cli_compiler__@vary__@vary__logs_expected_warning_message() {
  local RPI_CLI_MEMORY_ONLY_BOOLEAN="${TEST_MEMORY_MODE_BOOLEAN}"
  local RPI_PATH_COMPILED_ROOT="${test_path_compiled_root}"
  local RPI_PATH_COMPILED_CLI="${test_path_compiled_content}"
  local RPI_PATH_COMPILED_CLI_SOURCE="${RPI_WORKING_DIRECTORY}/lib/cli/compiler/tests/__fixtures__/${TEST_SCENARIO_NAME}_cli_configuration.txt"

  _cli_compiler_cli > /dev/null 2>&1

  _cli_log_warning.mock.assert_called_once_with "1(CLI: Compiling ...)"
}

@parametrize.compose \
  test_cli_compiler__@vary__@vary__logs_expected_warning_message \
  @parametrize_with_compiler_integration_scenarios \
  @parametrize_with_mode_options

# shellcheck disable=SC2034
test_cli_compiler__@vary__@vary__generates_expected_output_content() {
  local RPI_CLI_MEMORY_ONLY_BOOLEAN="${TEST_MEMORY_MODE_BOOLEAN}"
  local RPI_PATH_COMPILED_ROOT="${test_path_compiled_root}"
  local RPI_PATH_COMPILED_CLI="${test_path_compiled_content}"
  local RPI_PATH_COMPILED_CLI_SOURCE="${RPI_WORKING_DIRECTORY}/lib/cli/compiler/tests/__fixtures__/${TEST_SCENARIO_NAME}_cli_configuration.txt"
  local test_compiled_menus=()

  stdlib.array.make.from_string test_compiled_menus "|" "${TEST_COMPILE_MENUS_DEFINITION}"

  _capture.output _cli_compiler_cli

  assert_matches "$(stdlib.array.map.format "  PICTL: Compiled %s\n" test_compiled_menus)

real	0m[0-9]+\.[0-9]+s
user	0m[0-9]+\.[0-9]+s
sys	0m[0-9]+\.[0-9]+s" \
    "${TEST_OUTPUT}"
}

@parametrize.compose \
  test_cli_compiler__@vary__@vary__generates_expected_output_content \
  @parametrize_with_compiler_integration_scenarios \
  @parametrize_with_mode_options

# shellcheck disable=SC2034
test_cli_compiler__@vary__@vary__logs_expected_success_message() {
  local RPI_CLI_MEMORY_ONLY_BOOLEAN="${TEST_MEMORY_MODE_BOOLEAN}"
  local RPI_PATH_COMPILED_ROOT="${test_path_compiled_root}"
  local RPI_PATH_COMPILED_CLI="${test_path_compiled_content}"
  local RPI_PATH_COMPILED_CLI_SOURCE="${RPI_WORKING_DIRECTORY}/lib/cli/compiler/tests/__fixtures__/${TEST_SCENARIO_NAME}_cli_configuration.txt"

  _cli_compiler_cli > /dev/null 2>&1

  _cli_log_success.mock.assert_called_once_with "1(CLI: Ready to go!)"
}

@parametrize.compose \
  test_cli_compiler__@vary__@vary__logs_expected_success_message \
  @parametrize_with_compiler_integration_scenarios \
  @parametrize_with_mode_options

# shellcheck disable=SC2034
test_cli_compiler__@vary__@vary__logs_in_the_correct_sequence() {
  local RPI_CLI_MEMORY_ONLY_BOOLEAN="${TEST_MEMORY_MODE_BOOLEAN}"
  local RPI_PATH_COMPILED_ROOT="${test_path_compiled_root}"
  local RPI_PATH_COMPILED_CLI="${test_path_compiled_content}"
  local RPI_PATH_COMPILED_CLI_SOURCE="${RPI_WORKING_DIRECTORY}/lib/cli/compiler/tests/__fixtures__/${TEST_SCENARIO_NAME}_cli_configuration.txt"

  _mock.sequence.record.start

  _cli_compiler_cli > /dev/null 2>&1

  _mock.sequence.assert_is \
    "_cli_log_warning" \
    "date" \
    "_cli_log_success"
}

@parametrize.compose \
  test_cli_compiler__@vary__@vary__logs_in_the_correct_sequence \
  @parametrize_with_compiler_integration_scenarios \
  @parametrize_with_mode_options
