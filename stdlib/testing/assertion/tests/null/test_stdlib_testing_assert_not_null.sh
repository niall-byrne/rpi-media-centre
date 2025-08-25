#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

test_stdlib_testing_assert_not_null__when_not_null__succeeds_as_expected() {
  assert_not_null "not_null"
}

test_stdlib_testing_assert_not_null__when_is_null___fails_as_expected() {
  _capture_assertion_failure assert_not_null ""

  assert_equals \
    " $(_testing.assert.message.get ASSERT_ERROR_VALUE_NULL)"$'\n'" expected different value than [] but was the same" \
    "${TEST_OUTPUT}"
}
