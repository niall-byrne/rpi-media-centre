#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

test_stdlib_testing_assert_output_null__when_not_null__fails_as_expected() {
  _mock.create test_mock
  test_mock.mock.set.stdout "not_null"

  _capture.output test_mock
  _capture_assertion_failure assert_output_null

  assert_equals \
    " $(_testing.assert.message.get ASSERT_ERROR_VALUE_NOT_NULL "not_null")"$'\n'" expected [] but was [not_null]" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_assert_output_null__when_is_null___succeeds_as_expected() {
  _mock.create test_mock

  _capture.output test_mock

  assert_output_null
}
