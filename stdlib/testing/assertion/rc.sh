#!/bin/bash

# stdlib return code extensions to bash_unit assertions

set -eo pipefail

assert_rc() {
  # $1: the expected return status code

  local expected_status_code="${1}"

  _testing.__assertion.value.check "${expected_status_code}"

  if [[ -z "${TEST_RC}" ]]; then
    fail " the 'TEST_RC' value is empty, consider using '_capture.rc'"
  fi

  assert_equals "${expected_status_code}" "${TEST_RC}" " the expected status code was not returned"
}
