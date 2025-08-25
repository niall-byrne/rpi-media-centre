#!/bin/bash

# stdlib return code extensions to bash_unit assertions

builtin set -eo pipefail

assert_rc() {
  # $1: the expected return code

  if [[ -z "${TEST_RC}" ]]; then
    fail " $(_testing.assert.message.get ASSERT_ERROR_RC_NULL)"
  fi

  assert_equals "${1}" \
    "${TEST_RC}" \
    " $(_testing.assert.message.get ASSERT_ERROR_RC_NON_MATCHING)"
}
