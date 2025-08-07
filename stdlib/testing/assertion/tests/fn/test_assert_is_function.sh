#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

setup() {
  _mock.create stdlib.fn.query.is_fn
}

test_assert_is_function__when_not_a_function__fails_as_expected() {
  stdlib.fn.query.is_fn.mock.set.rc "1"

  _capture_assertion_failure assert_is_function "mock_invalid_name"

  assert_equals \
    " 'mock_invalid_name' is NOT a function" \
    "${TEST_OUTPUT}"
}

test_assert_is_function__when_is_a_function__succeeds_expected() {
  stdlib.fn.query.is_fn.mock.set.rc "0"

  assert_is_function "mock_fn_name"
}
