#!/bin/bash
# @file snapshot.sh
# @brief A library of snapshot assertions for testing.
# @description
#   This library provides a snapshot assertion function for use with a testing framework like `bash_unit`.
#   It compares the captured output with the content of a snapshot file.

# stdlib snapshot extensions to bash_unit assertions

set -eo pipefail

# @description Asserts that the captured output matches the content of a snapshot file.
# @arg $1 string A path relative to the test directory containing a text file.
# @env TEST_OUTPUT The captured output to check.
assert_snapshot() {
  local expected_output
  local snapshot_filename="${1}"

  _testing.__assertion.value.check "${snapshot_filename}"

  if [[ ! -f "${snapshot_filename}" ]]; then
    fail " the file '${snapshot_filename}' does not exist"
  fi

  expected_output="$(< "${snapshot_filename}")"

  assert_equals "${expected_output}" "${TEST_OUTPUT}" " the contents of '${snapshot_filename}' does not match the received output"
}
