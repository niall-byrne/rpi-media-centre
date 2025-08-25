#!/bin/bash

@parametrize_with_sequences() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_EXISTING_SEQUENCE_DEFINITION" \
    "existing_sequence___;value1|value2" \
    "no_existing_sequence;;"
}

test_stdlib_testing_mock_persistence_sequence_update__@vary__outputs_array_definition_to_persistence_file() {
  local __MOCK_SEQUENCE=()
  local __MOCK_SEQUENCE_PERSISTENCE_FILE="/dev/stderr"
  local __MOCK_SEQUENCE_PERSISTED_ARRAY

  stdlib.array.make.from_string __MOCK_SEQUENCE "|" "${TEST_EXISTING_SEQUENCE_DEFINITION}"

  _capture.stderr __mock.persistence.sequence.update

  __MOCK_SEQUENCE_PERSISTED_ARRAY=("${__MOCK_SEQUENCE[@]}")
  assert_output "$(declare -p __MOCK_SEQUENCE_PERSISTED_ARRAY)"
}

@parametrize_with_sequences \
  test_stdlib_testing_mock_persistence_sequence_update__@vary__outputs_array_definition_to_persistence_file
