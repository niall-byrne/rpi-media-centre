#!/bin/bash

# stdlib output extensions to bash_unit assertions

builtin set -eo pipefail

assert_output() {
  # $1: the expected output

  if [[ -z "${TEST_OUTPUT}" ]]; then
    fail " $(_testing.assert.message.get ASSERT_ERROR_OUTPUT_NULL)"
  fi

  assert_equals "${1}" \
    "${TEST_OUTPUT}" \
    " $(_testing.assert.message.get ASSERT_ERROR_OUTPUT_NON_MATCHING)"
}

assert_output_null() {
  assert_equals "" \
    "${TEST_OUTPUT}" \
    " $(_testing.assert.message.get ASSERT_ERROR_VALUE_NOT_NULL "${TEST_OUTPUT}")"
}

assert_output_raw() {
  # $1: the expected output

  if [[ -z "${TEST_OUTPUT}" ]]; then
    fail " $(_testing.assert.message.get ASSERT_ERROR_OUTPUT_NULL)"
  fi

  assert_equals "${1}" \
    "${TEST_OUTPUT}" \
    " $(_testing.assert.message.get ASSERT_ERROR_OUTPUT_NON_MATCHING)"
}
