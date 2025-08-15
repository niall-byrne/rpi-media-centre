#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

setup() {
  _mock.create stdlib.array.query.is_array
}

test_assert_is_array__when_not_a_function__calls_stdlib_fn_query_as_expected() {
  stdlib.array.query.is_array.mock.set.rc "1"

  _capture_assertion_failure assert_is_array "mock_invalid_name"

  stdlib.array.query.is_array.mock.assert_called_once_with "mock_invalid_name"
}

test_assert_is_array__when_not_a_function__fails_as_expected() {
  stdlib.array.query.is_array.mock.set.rc "1"

  _capture_assertion_failure assert_is_array "mock_invalid_name"

  assert_equals \
    " 'mock_invalid_name' is NOT an array" \
    "${TEST_OUTPUT}"
}

test_assert_is_array__when_is_a_function___calls_stdlib_fn_query_as_expected() {
  stdlib.array.query.is_array.mock.set.rc "0"

  assert_is_array "mock_valid_name"

  stdlib.array.query.is_array.mock.assert_called_once_with "mock_valid_name"
}

test_assert_is_array__when_is_a_function___succeeds_expected() {
  stdlib.array.query.is_array.mock.set.rc "0"

  assert_is_array "mock_valid_name"
}
