#!/bin/bash

setup() {
  _mock.create mock1
  _mock.create mock2
  _mock.create mock3

  _mock.sequence.clear
  _mock.sequence.record.stop
}

teardown() {
  _mock.sequence.record.stop
}

test_stdlib_testing_mock_sequence_record_resume__no_subshell__0_calls__record_not_started__3_calls__records_0_calls() {
  mock3
  mock2
  mock1

  _mock.sequence.assert_is_empty
}

test_stdlib_testing_mock_sequence_record_resume__subshell_____0_calls__record_not_started__3_calls__records_0_calls() {
  (
    mock3
    mock2
    mock1
  )

  _mock.sequence.assert_is_empty
}

test_stdlib_testing_mock_sequence_record_resume__no_subshell__0_calls__record_resumed______3_calls__records_3_calls() {
  _mock.sequence.record.resume
  mock3
  mock2
  mock1

  _mock.sequence.assert_is \
    "mock3" \
    "mock2" \
    "mock1"
}

test_stdlib_testing_mock_sequence_record_resume__subshell_____0_calls__record_resumed______3_calls__records_3_calls() {
  _mock.sequence.record.resume
  mock3
  (
    mock2
    mock1
  )

  _mock.sequence.assert_is \
    "mock3" \
    "mock2" \
    "mock1"
}

test_stdlib_testing_mock_sequence_record_resume__no_subshell__2_calls__record_resumed______1_call___records_3_calls() {
  _mock.sequence.record.start
  mock3
  mock2
  _mock.sequence.record.stop
  _mock.sequence.record.resume
  mock1

  _mock.sequence.assert_is \
    "mock3" \
    "mock2" \
    "mock1"
}

test_stdlib_testing_mock_sequence_record_resume__subshell_____2_calls__record_resumed______1_call___records_3_calls() {
  _mock.sequence.record.start
  mock3
  (
    mock2
  )
  _mock.sequence.record.stop
  _mock.sequence.record.resume
  mock1

  _mock.sequence.assert_is \
    "mock3" \
    "mock2" \
    "mock1"
}
