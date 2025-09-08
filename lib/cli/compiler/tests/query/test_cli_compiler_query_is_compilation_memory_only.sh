#!/bin/bash

@parametrize_with_memory_only_boolean() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_MEMORY_ONLY_BOOLEAN;TEST_EXPECTED_RC" \
    "memory_only;1;0" \
    "not_memory_only;0;1"
}

# shellcheck disable=SC2034
test_cli_compiler_query_is_compilation_memory_only__@vary__returns_expected_rc() {
  local RPI_CLI_MEMORY_ONLY_BOOLEAN="${TEST_MEMORY_ONLY_BOOLEAN}"

  _capture.rc _cli_compiler_query_is_compilation_memory_only

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_memory_only_boolean \
  test_cli_compiler_query_is_compilation_memory_only__@vary__returns_expected_rc
