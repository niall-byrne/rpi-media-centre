#!/bin/bash

setup_suite() {
  mock_persistence_file="$(mktemp)"
}

teardown_suite() {
  rm "${mock_persistence_file}"
}

@parametrize_with_sequences() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_EXISTING_SEQUENCE_DEFINITION;TEST_PERSISTED_SEQUENCE_DEFINITION" \
    "existing_sequence_____existing_definition___;value1|value2;value3|value4" \
    "existing_sequence_____no_existing_definition;value1|value2;;" \
    "no_existing_sequence__existing_definition___;;value1|value2" \
    "no_existing_sequence__no_existing_definition;;;"
}

test_stdlib_testing_mock_persistence_sequence_retrieve__@vary__replaces_sequence_with_persisted_definition() {
  local __MOCK_SEQUENCE=()
  local __MOCK_SEQUENCE_PERSISTENCE_FILE="${mock_persistence_file}"
  local __MOCK_SEQUENCE_PERSISTED_ARRAY=()

  stdlib.array.make.from_string __MOCK_SEQUENCE "|" "${TEST_EXISTING_SEQUENCE_DEFINITION}"
  stdlib.array.make.from_string __MOCK_SEQUENCE_PERSISTED_ARRAY "|" "${TEST_PERSISTED_SEQUENCE_DEFINITION}"
  declare -p __MOCK_SEQUENCE_PERSISTED_ARRAY > "${mock_persistence_file}"

  __mock.persistence.sequence.retrieve

  assert_array_equals __MOCK_SEQUENCE_PERSISTED_ARRAY __MOCK_SEQUENCE
}

@parametrize_with_sequences \
  test_stdlib_testing_mock_persistence_sequence_retrieve__@vary__replaces_sequence_with_persisted_definition
