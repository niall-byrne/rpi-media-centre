#!/bin/bash

setup() {
  _mock.create mock1
  _mock.create mock2
  _mock.create mock3

  _mock.sequence.record.start
}

teardown() {
  _mock.sequence.record.stop
}

test_stdlib_testing_mock_sequence_record_stop__record_stopped__three_calls__records_0_calls() {
  _mock.sequence.record.stop

  mock3
  mock2
  mock1

  _mock.sequence.assert_is_empty
}

test_stdlib_testing_mock_sequence_record_stop__record_started__three_calls__records_3_calls() {
  mock3
  mock2
  mock1

  _mock.sequence.assert_is \
    "mock3" \
    "mock2" \
    "mock1"
}
