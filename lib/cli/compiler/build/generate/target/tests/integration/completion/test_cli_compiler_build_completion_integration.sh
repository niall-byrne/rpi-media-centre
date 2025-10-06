#!/bin/bash

# shellcheck disable=SC2034
setup_suite() {
  test_path_compiled_root="$(mktemp -d)"
  test_path_compiled_content="${test_path_compiled_root}/completion.sh"
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
    "TEST_SCENARIO_NAME;TEST_COMPILE_MENUS_DEFINITION" \
    "scenario1;scenario1;test|command3" \
    "scenario2;scenario2;test_with_switches"
}

# shellcheck disable=SC2034
test_cli_compiler_build_generate_target_completion__@vary__generates_expected_bash_completion_content() {
  local RPI_PATH_FRAGMENTS="${RPI_WORKING_DIRECTORY}/lib/cli/compiler/build/generate/target/fragments"
  local RPI_PATH_COMPILED_ROOT="${test_path_compiled_root}"
  local RPI_PATH_COMPILED_COMPLETION="${test_path_compiled_content}"
  local RPI_PATH_COMPILED_CLI_SOURCE="${RPI_WORKING_DIRECTORY}/lib/cli/compiler/build/generate/target/tests/integration/__fixtures__/${TEST_SCENARIO_NAME}_cli_configuration.txt"

  _cli_compiler_build_generate_target_completion > /dev/null 2>&1

  TEST_OUTPUT="$(cat "${test_path_compiled_content}")"
  assert_snapshot "${RPI_WORKING_DIRECTORY}/lib/cli/compiler/build/generate/target/tests/integration/__fixtures__/${TEST_SCENARIO_NAME}_compiled_completion_snapshot.sh"
}

@parametrize_with_compiler_integration_scenarios \
  test_cli_compiler_build_generate_target_completion__@vary__generates_expected_bash_completion_content

# shellcheck disable=SC2034
test_cli_compiler_build_generate_target_completion__@vary__logs_expected_warning_message() {
  local RPI_PATH_FRAGMENTS="${RPI_WORKING_DIRECTORY}/lib/cli/compiler/build/generate/target/fragments"
  local RPI_PATH_COMPILED_ROOT="${test_path_compiled_root}"
  local RPI_PATH_COMPILED_COMPLETION="${test_path_compiled_content}"
  local RPI_PATH_COMPILED_CLI_SOURCE="${RPI_WORKING_DIRECTORY}/lib/cli/compiler/build/generate/target/tests/integration/__fixtures__/${TEST_SCENARIO_NAME}_cli_configuration.txt"

  _cli_compiler_build_generate_target_completion > /dev/null 2>&1

  _cli_log_warning.mock.assert_called_once_with "1(CLI: Compiling ...)"
}

@parametrize_with_compiler_integration_scenarios \
  test_cli_compiler_build_generate_target_completion__@vary__logs_expected_warning_message

# shellcheck disable=SC2034
test_cli_compiler_build_generate_target_completion__@vary__generates_expected_output_content() {
  local RPI_PATH_FRAGMENTS="${RPI_WORKING_DIRECTORY}/lib/cli/compiler/build/generate/target/fragments"
  local RPI_PATH_COMPILED_ROOT="${test_path_compiled_root}"
  local RPI_PATH_COMPILED_COMPLETION="${test_path_compiled_content}"
  local RPI_PATH_COMPILED_CLI_SOURCE="${RPI_WORKING_DIRECTORY}/lib/cli/compiler/build/generate/target/tests/integration/__fixtures__/${TEST_SCENARIO_NAME}_cli_configuration.txt"
  local test_compiled_menus=()

  stdlib.array.make.from_string test_compiled_menus "|" "${TEST_COMPILE_MENUS_DEFINITION}"

  _capture.output _cli_compiler_build_generate_target_completion

  assert_matches "$(stdlib.array.map.format "  PICTL: Compiled %s\n" test_compiled_menus)

real	0m[0-9]+\.[0-9]+s
user	0m[0-9]+\.[0-9]+s
sys	0m[0-9]+\.[0-9]+s" \
    "${TEST_OUTPUT}"
}

@parametrize_with_compiler_integration_scenarios \
  test_cli_compiler_build_generate_target_completion__@vary__generates_expected_output_content

# shellcheck disable=SC2034
test_cli_compiler_build_generate_target_completion__@vary__logs_expected_success_message() {
  local RPI_PATH_FRAGMENTS="${RPI_WORKING_DIRECTORY}/lib/cli/compiler/build/generate/target/fragments"
  local RPI_PATH_COMPILED_ROOT="${test_path_compiled_root}"
  local RPI_PATH_COMPILED_COMPLETION="${test_path_compiled_content}"
  local RPI_PATH_COMPILED_CLI_SOURCE="${RPI_WORKING_DIRECTORY}/lib/cli/compiler/build/generate/target/tests/integration/__fixtures__/${TEST_SCENARIO_NAME}_cli_configuration.txt"

  _cli_compiler_build_generate_target_completion > /dev/null 2>&1

  _cli_log_success.mock.assert_called_once_with "1(CLI: Ready to go!)"
}

@parametrize_with_compiler_integration_scenarios \
  test_cli_compiler_build_generate_target_completion__@vary__logs_expected_success_message

# shellcheck disable=SC2034
test_cli_compiler_build_generate_target_completion__@vary__logs_in_the_correct_sequence() {
  local RPI_PATH_FRAGMENTS="${RPI_WORKING_DIRECTORY}/lib/cli/compiler/build/generate/target/fragments"
  local RPI_PATH_COMPILED_ROOT="${test_path_compiled_root}"
  local RPI_PATH_COMPILED_COMPLETION="${test_path_compiled_content}"
  local RPI_PATH_COMPILED_CLI_SOURCE="${RPI_WORKING_DIRECTORY}/lib/cli/compiler/build/generate/target/tests/integration/__fixtures__/${TEST_SCENARIO_NAME}_cli_configuration.txt"

  _mock.sequence.record.start

  _cli_compiler_build_generate_target_completion > /dev/null 2>&1

  _mock.sequence.assert_is \
    "_cli_log_warning" \
    "date" \
    "_cli_log_success"
}

@parametrize_with_compiler_integration_scenarios \
  test_cli_compiler_build_generate_target_completion__@vary__logs_in_the_correct_sequence
