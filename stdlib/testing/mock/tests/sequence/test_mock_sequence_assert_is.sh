#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

setup() {
  _mock.create mock1
  _mock.create mock2
  _mock.create mock3
}

test_mock_assert_sequence_is__no_args__________fails() {
  _capture_assertion_failure _mock.sequence.assert_is

  assert_equals \
    " '_mock.sequence.assert_is' was not given sufficient arguments" \
    "${TEST_OUTPUT}"
}

test_mock_assert_sequence_is__wrong_arg_count__succeeds() {
  mock3
  mock2
  mock1

  _capture_assertion_failure _mock.sequence.assert_is "mock1"

  assert_equals \
    " the array 'EXPECTED_MOCK_SEQUENCE' has length '1', the array 'MOCK_SEQUENCE' has length '3'
 expected [1] but was [3]" \
    "${TEST_OUTPUT}"
}

test_mock_assert_sequence_is__wrong_arg_order__succeeds() {
  mock3
  mock2
  mock1

  _capture_assertion_failure _mock.sequence.assert_is "mock1" "mock2" "mock1"

  assert_equals \
    " at index '0' the array 'EXPECTED_MOCK_SEQUENCE' has element 'mock1', array 'MOCK_SEQUENCE' has element 'mock3'
 expected [mock1] but was [mock3]" \
    "${TEST_OUTPUT}"
}

test_mock_assert_sequence_is__correct_args_____succeeds() {
  mock3
  mock2
  mock1

  _mock.sequence.assert_is "mock3" "mock2" "mock1"
}
