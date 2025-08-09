#!/bin/bash

load "${RPI_WORKING_DIRECTORY}/lib/testing/tests/assertions/capture.sh"

setup() {
  _mock.create stdlib.array.query.is_array
}

test_assert_is_array__when_not_an_array__fails_as_expected() {
  stdlib.array.query.is_array.mock.set.rc "1"

  _capture_assertion_failure assert_is_array "mock_invalid_array_name"

  assert_equals \
    " 'mock_invalid_array_name' is NOT an array" \
    "${TEST_OUTPUT}"
}

test_assert_is_array__when_is_an_array__succeeds_as_expected() {
  stdlib.array.query.is_array.mock.set.rc "0"

  _capture_assertion_failure assert_is_array "mock_valid_array_name"

  assert_equals \
    " 'mock_valid_array_name' is NOT an array" \
    "${TEST_OUTPUT}"
}
