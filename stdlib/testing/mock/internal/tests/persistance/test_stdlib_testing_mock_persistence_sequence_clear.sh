#!/bin/bash

setup() {
  __MOCK_SEQUENCE_TRACKING="0"

  _mock.create __mock.persistence.sequence.update
}

@parametrize_with_sequences() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_EXISTING_SEQUENCE_DEFINITION" \
    "existing_sequence___;value1|value2" \
    "no_existing_sequence;;"
}

# shellcheck disable=SC2034
test_stdlib_testing_mock_persistence_sequence_clear__@vary__clears_array() {
  local __MOCK_SEQUENCE=()
  local empty_array=()

  stdlib.array.make.from_string __MOCK_SEQUENCE "|" "${TEST_EXISTING_SEQUENCE_DEFINITION}"

  __mock.persistence.sequence.clear

  assert_array_equals empty_array __MOCK_SEQUENCE
}

@parametrize_with_sequences \
  test_stdlib_testing_mock_persistence_sequence_clear__@vary__clears_array

test_stdlib_testing_mock_persistence_sequence_clear__@vary__calls_mocked_persistence_update() {
  local __MOCK_SEQUENCE=()

  stdlib.array.make.from_string __MOCK_SEQUENCE "|" "${TEST_EXISTING_SEQUENCE_DEFINITION}"

  __mock.persistence.sequence.clear

  __mock.persistence.sequence.update.mock.assert_called_once_with ""
}

@parametrize_with_sequences \
  test_stdlib_testing_mock_persistence_sequence_clear__@vary__calls_mocked_persistence_update
