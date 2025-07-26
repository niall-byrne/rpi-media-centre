#!/bin/bash

test_cli_pretty_env_var__arg__correct_output() {
  TEST_EXPECTED="$(cat "${RPI_WORKING_DIRECTORY}/lib/cli/pretty/tests/pretty/__fixtures__/env_var_pretty.txt")"
  TEST_INPUT="$(cat "${RPI_WORKING_DIRECTORY}/lib/cli/pretty/tests/pretty/__fixtures__/env_var.txt")"

  _capture_output _cli_pretty_env_var "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_cli_pretty_env_var__pipe__correct_output() {
  TEST_EXPECTED="$(cat "${RPI_WORKING_DIRECTORY}/lib/cli/pretty/tests/pretty/__fixtures__/env_var_pretty.txt")"
  TEST_INPUT="$(cat "${RPI_WORKING_DIRECTORY}/lib/cli/pretty/tests/pretty/__fixtures__/env_var.txt")"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | _cli_pretty_env_var)"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
