#!/bin/bash

# stdlib null extensions to bash_unit assertions

builtin set -eo pipefail

assert_null() {
  # $1: the value to check

  local _stdlib_test_value="${1}"

  assert_equals "" \
    "${_stdlib_test_value}" \
    " $(_testing.assert.message.get ASSERT_ERROR_VALUE_NOT_NULL "${_stdlib_test_value}")"
}

assert_not_null() {
  # $1: the value to check

  local _stdlib_test_value="${1}"

  assert_not_equals "" \
    "${_stdlib_test_value}" \
    " $(_testing.assert.message.get ASSERT_ERROR_VALUE_NULL)"
}
