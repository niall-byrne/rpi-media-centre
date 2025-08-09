#!/bin/bash

# stdlib output extensions to bash_unit assertions

set -eo pipefail

assert_output() {
  # $1: the expected output string to match

  local expected_output_string="${1}"

  _testing.__assertion.value.check "${expected_output_string}"

  if [[ -z "${TEST_OUTPUT}" ]]; then
    fail " the 'TEST_OUTPUT' value is empty, consider using '_capture_output'"
  fi

  assert_equals "${expected_output_string}" "${TEST_OUTPUT}" " the expected output string was not generated"
}
