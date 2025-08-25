#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

setup() {
  _mock.create mock1
  _mock.create mock2
  _mock.create mock3

  _mock.sequence.record.start
}

test_stdlib_testing_mock_sequence_assert_is__no_args__________fails() {
  _capture_assertion_failure _mock.sequence.assert_is

  assert_equals \
    " '_mock.sequence.assert_is' $(stdlib.message.get ARGUMENTS_INVALID)" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_sequence_assert_is__wrong_arg_count__fails() {
  mock3
  mock2
  mock1

  _capture_assertion_failure _mock.sequence.assert_is "mock3"

  assert_equals \
    " $(
      local _STDLIB_LOGGING_MESSAGE_PREFIX

      _STDLIB_LOGGING_MESSAGE_PREFIX="assert_array_equals" \
        stdlib.logger.error "$(stdlib.message.get ARRAY_LENGTH_MISMATCH "expected_mock_sequence" "1")" 2>&1
      _STDLIB_LOGGING_MESSAGE_PREFIX=" assert_array_equals" \
        stdlib.logger.error "$(stdlib.message.get ARRAY_LENGTH_MISMATCH "mock_sequence" "3")" 2>&1
    )" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_sequence_assert_is__wrong_arg_order__fails() {
  mock3
  mock2
  mock1

  _capture_assertion_failure _mock.sequence.assert_is "mock1" "mock2" "mock1"

  assert_equals \
    " $(
      local _STDLIB_LOGGING_MESSAGE_PREFIX

      _STDLIB_LOGGING_MESSAGE_PREFIX="assert_array_equals" \
        stdlib.logger.error "$(stdlib.message.get ARRAY_ELEMENT_MISMATCH "expected_mock_sequence" "0" "mock1")" 2>&1
      _STDLIB_LOGGING_MESSAGE_PREFIX=" assert_array_equals" \
        stdlib.logger.error "$(stdlib.message.get ARRAY_ELEMENT_MISMATCH "mock_sequence" "0" "mock3")" 2>&1
    )" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_sequence_assert_is__correct_args_____succeeds() {
  mock3
  mock2
  mock1

  _mock.sequence.assert_is "mock3" "mock2" "mock1"
}

test_stdlib_testing_mock_sequence_assert_is__correct_args_____stops_recording() {
  mock3
  mock2
  mock1

  _mock.sequence.assert_is "mock3" "mock2" "mock1"

  mock1

  _mock.sequence.assert_is "mock3" "mock2" "mock1"
}
