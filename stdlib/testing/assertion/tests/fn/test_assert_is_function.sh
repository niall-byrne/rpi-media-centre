#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

setup() {
  _mock.create stdlib.fn.query.is_fn
}

test_assert_is_fn__when_not_a_function__calls_stdlib_fn_query_as_expected() {
  stdlib.fn.query.is_fn.mock.set.rc "1"

  _capture_assertion_failure assert_is_fn "mock_invalid_name"

  stdlib.fn.query.is_fn.mock.assert_called_once_with "mock_invalid_name"
}

test_assert_is_fn__when_not_a_function__fails_as_expected() {
  stdlib.fn.query.is_fn.mock.set.rc "1"

  _capture_assertion_failure assert_is_fn "mock_invalid_name"

  assert_equals \
    " 'mock_invalid_name' is NOT a function" \
    "${TEST_OUTPUT}"
}

test_assert_is_fn__when_is_a_function___calls_stdlib_fn_query_as_expected() {
  stdlib.fn.query.is_fn.mock.set.rc "0"

  assert_is_fn "mock_valid_name"

  stdlib.fn.query.is_fn.mock.assert_called_once_with "mock_valid_name"
}

test_assert_is_fn__when_is_a_function___succeeds_expected() {
  stdlib.fn.query.is_fn.mock.set.rc "0"

  assert_is_fn "mock_valid_name"
}
