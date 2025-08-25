#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

setup() {
  _mock.create mock1
  _mock.create mock2

  _mock.sequence.record.start
}

test_stdlib_testing_mock_sequence_assert_is_empty__sequence_not_empty__fails() {
  mock1
  mock2

  _capture_assertion_failure _mock.sequence.assert_is_empty

  assert_equals \
    " $(
      local _STDLIB_LOGGING_MESSAGE_PREFIX

      _STDLIB_LOGGING_MESSAGE_PREFIX="assert_array_equals" \
        stdlib.logger.error "$(stdlib.message.get ARRAY_LENGTH_MISMATCH "expected_mock_sequence" "0")" 2>&1
      _STDLIB_LOGGING_MESSAGE_PREFIX=" assert_array_equals" \
        stdlib.logger.error "$(stdlib.message.get ARRAY_LENGTH_MISMATCH "mock_sequence" "2")" 2>&1
    )" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_sequence_assert_is_empty__sequence_empty______succeeds() {
  _mock.sequence.assert_is_empty
}

test_stdlib_testing_mock_sequence_assert_is_empty__sequence_empty______stops_recording() {
  _mock.sequence.assert_is_empty

  mock1

  _mock.sequence.assert_is_empty
}
