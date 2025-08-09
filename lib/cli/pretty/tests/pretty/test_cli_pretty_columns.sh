#!/bin/bash

test_cli_pretty_columns__arg__correct_output() {
  TEST_EXPECTED="$(cat "${RPI_WORKING_DIRECTORY}/lib/cli/pretty/tests/pretty/__fixtures__/columns_pretty.txt")"
  TEST_INPUT="$(cat "${RPI_WORKING_DIRECTORY}/lib/cli/pretty/tests/pretty/__fixtures__/columns.txt")"

  _capture.output _cli_pretty_columns "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_cli_pretty_columns__pipe__correct_output() {
  TEST_EXPECTED="$(cat "${RPI_WORKING_DIRECTORY}/lib/cli/pretty/tests/pretty/__fixtures__/columns_pretty.txt")"
  TEST_INPUT="$(cat "${RPI_WORKING_DIRECTORY}/lib/cli/pretty/tests/pretty/__fixtures__/columns.txt")"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | _cli_pretty_columns)"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
