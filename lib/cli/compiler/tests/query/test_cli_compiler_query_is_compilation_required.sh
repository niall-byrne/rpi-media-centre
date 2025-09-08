#!/bin/bash

setup() {
  _mock.create _cli_compiler_query_is_compilation_forced
  _mock.create _cli_compiler_query_is_compilation_memory_only
  _mock.create _cli_compiler_query_is_existing_cli_compatible
}

@parametrize_with_all_conditions() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_IS_FORCED_RC;TEST_IS_MEMORY_ONLY_RC;TEST_IS_COMPATIBLE_RC;TEST_EXPECTED_RC;TEST_EXPECTED_OUTPUT" \
    "forced______not_memory_and_compatible;0;1;0;0;CLI compilation has been requested ...;" \
    "forced______not_memory_and_not_compatible;0;1;1;0;CLI compilation has been requested ...;" \
    "forced______memory_and_compatible;0;0;0;0;CLI compilation has been requested ...;" \
    "forced______memory_and_not_compatible;0;0;1;0;CLI compilation has been requested ...;" \
    "not_forced__memory_and_compatible;1;0;0;0;CLI is running in configured for memory only, compilation required...;" \
    "not_forced__memory_and_not_compatible;1;0;1;0;CLI is running in configured for memory only, compilation required...;" \
    "not_forced__not_memory_and_not_compatible;1;1;1;0;;" \
    "not_forced__not_memory_and_compatible;1;1;0;1;;"
}

test_cli_compiler_query_is_compilation_required__@vary__returns_expected_rc() {
  _cli_compiler_query_is_compilation_forced.mock.set.rc "${TEST_IS_FORCED_RC}"
  _cli_compiler_query_is_compilation_memory_only.mock.set.rc "${TEST_IS_MEMORY_ONLY_RC}"
  _cli_compiler_query_is_existing_cli_compatible.mock.set.rc "${TEST_IS_COMPATIBLE_RC}"

  _capture.rc _cli_compiler_query_is_compilation_required > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_all_conditions \
  test_cli_compiler_query_is_compilation_required__@vary__returns_expected_rc

test_cli_compiler_query_is_compilation_required__@vary__echos_correct_message() {
  _cli_compiler_query_is_compilation_forced.mock.set.rc "${TEST_IS_FORCED_RC}"
  _cli_compiler_query_is_compilation_memory_only.mock.set.rc "${TEST_IS_MEMORY_ONLY_RC}"
  _cli_compiler_query_is_existing_cli_compatible.mock.set.rc "${TEST_IS_COMPATIBLE_RC}"

  _capture.stdout _cli_compiler_query_is_compilation_required

  assert_equals "${TEST_EXPECTED_OUTPUT}" "${TEST_OUTPUT}"
}

@parametrize_with_all_conditions \
  test_cli_compiler_query_is_compilation_required__@vary__echos_correct_message
