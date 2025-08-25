#!/bin/bash

# stdlib snapshot extensions to bash_unit assertions

builtin set -eo pipefail

assert_snapshot() {
  # $1: a path relative to the test directory containing a text file

  local _stdlib_expected_output
  local _stdlib_snapshot_filename="${1}"

  _testing.__assertion.value.check "${_stdlib_snapshot_filename}"

  if [[ ! -f "${_stdlib_snapshot_filename}" ]]; then
    fail " $(_testing.assert.message.get ASSERT_ERROR_FILE_NOT_FOUND "${_stdlib_snapshot_filename}")"
  fi

  _stdlib_expected_output="$(< "${_stdlib_snapshot_filename}")"

  assert_equals "${_stdlib_expected_output}" \
    "${TEST_OUTPUT}" \
    " $(_testing.assert.message.get ASSERT_ERROR_SNAPSHOT_NON_MATCHING "${_stdlib_snapshot_filename}")"
}
