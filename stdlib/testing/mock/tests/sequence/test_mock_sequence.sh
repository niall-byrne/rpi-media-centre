#!/bin/bash

setup() {
  _mock.create mock1
  _mock.create mock2
  _mock.create mock3
}

test_mock_sequence__two_elements() {
  mock1
  mock2

  _mock.sequence.assert_is "mock1" "mock2"
}

test_mock_sequence__two_elements____after__verify_sequence_has_test_isolation() {
  _mock.sequence.assert_is_empty
}

test_mock_sequence__three_elements() {
  mock1
  mock2
  mock3

  _mock.sequence.assert_is "mock1" "mock2" "mock3"
}

test_mock_sequence__three_elements__after__verify_sequence_has_test_isolation() {
  _mock.sequence.assert_is_empty
}
