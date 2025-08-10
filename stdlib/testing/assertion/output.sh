#!/bin/bash
# @file output.sh
# @brief A library of output assertions for testing.
# @description
#   This library provides an output assertion function for use with a testing framework like `bash_unit`.
#   It relies on the `TEST_OUTPUT` environment variable being set by a capture function.

# stdlib output extensions to bash_unit assertions

set -eo pipefail

# @description Asserts that the captured output matches an expected string.
# @arg $1 string The expected output string to match.
# @env TEST_OUTPUT The captured output to check.
assert_output() {
  local expected_output_string="${1}"

  _testing.__assertion.value.check "${expected_output_string}"

  if [[ -z "${TEST_OUTPUT}" ]]; then
    fail " the 'TEST_OUTPUT' value is empty, consider using '_capture_output'"
  fi

  assert_equals "${expected_output_string}" "${TEST_OUTPUT}" " the expected output string was not generated"
}
