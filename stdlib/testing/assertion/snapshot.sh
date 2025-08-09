#!/bin/bash

# stdlib snapshot extensions to bash_unit assertions

set -eo pipefail

assert_snapshot() {
  # $1: a path relative to the test directory containing a text file

  local expected_output
  local snapshot_filename="${1}"

  _testing.__assertion.value.check "${snapshot_filename}"

  if [[ ! -f "${snapshot_filename}" ]]; then
    fail " the file '${snapshot_filename}' does not exist"
  fi

  expected_output="$(< "${snapshot_filename}")"

  assert_equals "${expected_output}" "${TEST_OUTPUT}" " the contents of '${snapshot_filename}' does not match the received output"
}
