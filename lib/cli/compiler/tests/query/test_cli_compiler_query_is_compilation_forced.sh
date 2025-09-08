#!/bin/bash

@parametrize_with_forced_and_just_compiled_booleans() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_FORCED_BOOLEAN;TEST_JUST_COMPILED_BOOLEAN;TEST_EXPECTED_RC" \
    "forced_and_just_compiled;1;1;1" \
    "forced_and_not_just_compiled;1;0;0" \
    "not_forced_and_just_compiled;0;1;1" \
    "not_forced_and_not_just_compiled;0;0;1"
}

# shellcheck disable=SC2034
test_cli_compiler_query_is_compilation_forced__@vary__returns_expected_rc() {
  local RPI_CLI_COMPILER_FORCED_BOOLEAN="${TEST_FORCED_BOOLEAN}"
  local RPI_CLI_JUST_COMPILED_BOOLEAN="${TEST_JUST_COMPILED_BOOLEAN}"

  _capture.rc _cli_compiler_query_is_compilation_forced

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_forced_and_just_compiled_booleans \
  test_cli_compiler_query_is_compilation_forced__@vary__returns_expected_rc
