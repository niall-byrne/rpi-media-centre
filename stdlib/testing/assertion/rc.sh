#!/bin/bash
# @file rc.sh
# @brief A library of return code assertions for testing.
# @description
#   This library provides a return code assertion function for use with a testing framework like `bash_unit`.
#   It relies on the `TEST_RC` environment variable being set by a capture function.

# stdlib return code extensions to bash_unit assertions

set -eo pipefail

# @description Asserts that the captured return code matches an expected value.
# @arg $1 integer The expected return status code.
# @env TEST_RC The captured return code to check.
assert_rc() {
  local expected_status_code="${1}"

  _testing.__assertion.value.check "${expected_status_code}"

  if [[ -z "${TEST_RC}" ]]; then
    fail " the 'TEST_RC' value is empty, consider using '_capture_rc'"
  fi

  assert_equals "${expected_status_code}" "${TEST_RC}" " the expected status code was not returned"
}
