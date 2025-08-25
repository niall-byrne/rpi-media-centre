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

test_stdlib_testing_mock_sequence_clear__empty___________performs_a_noop() {
  _mock.sequence.clear

  _mock.sequence.assert_is_empty
}

test_stdlib_testing_mock_sequence_clear__three_elements__clears_sequence() {
  mock3
  mock2
  mock1

  _mock.sequence.clear

  _mock.sequence.assert_is_empty
}
