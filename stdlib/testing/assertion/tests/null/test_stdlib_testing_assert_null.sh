#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

test_stdlib_testing_assert_null__when_not_null__fails_as_expected() {
  _capture_assertion_failure assert_null "not_null"

  assert_equals \
    " $(_testing.assert.message.get ASSERT_ERROR_VALUE_NOT_NULL "not_null")"$'\n'" expected [] but was [not_null]" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_assert_null__when_is_null___succeeds_as_expected() {
  assert_null ""
}
