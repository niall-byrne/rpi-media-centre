#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

setup() {
  _mock.create mock1
  _mock.create mock2
}

test_mock_sequence_assert_sequence_empty__sequence_not_empty__fails() {
  mock1
  mock2

  _capture_assertion_failure _mock.sequence.assert_is_empty

  assert_equals \
    " the array 'expected_mock_sequence' has length '0', the array 'mock_sequence' has length '2'
 expected [0] but was [2]" \
    "${TEST_OUTPUT}"
}

test_mock_sequence_assert_sequence_empty__sequence_empty______succeeds() {
  _mock.sequence.assert_is_empty
}
