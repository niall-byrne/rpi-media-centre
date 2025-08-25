#!/bin/bash

setup() {
  _mock.create test_mock_1
  _mock.create test_mock_2
  _mock.create test_mock_3

  __mock.persistence.sequence.clear
}

teardown() {
  _fixture_disable_tracking
}

@parametrize_with_sequence_tracking() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_COMMAND_DEFINITION;TEST_EXPECTED_SEQUENCE_DEFINITION" \
    "tracking_enabled_all__;_fixture_enable_tracking|test_mock_1|test_mock_2|test_mock_3;test_mock_1|test_mock_2|test_mock_3" \
    "tracking_disabled_all_;_fixture_disable_tracking|test_mock_1|test_mock_2|test_mock_3;;" \
    "tracking_enabled_first;_fixture_enable_tracking|test_mock_1|_fixture_disable_tracking|test_mock_2|test_mock_3;test_mock_1" \
    "tracking_enabled_last_;_fixture_disable_tracking|test_mock_1|test_mock_2|_fixture_enable_tracking|test_mock_3;test_mock_3"
}

_fixture_disable_tracking() {
  __MOCK_SEQUENCE_TRACKING="0"
}

_fixture_enable_tracking() {
  __MOCK_SEQUENCE_TRACKING="1"
}

# shellcheck disable=SC2034
test_stdlib_testing_mock_object_sequence__@vary__updates_sequence() {
  local __MOCK_SEQUENCE_TRACKING=""
  local expected_sequence=()
  local commands=()
  local command

  stdlib.array.make.from_string commands "|" "${TEST_COMMAND_DEFINITION}"
  stdlib.array.make.from_string expected_sequence "|" "${TEST_EXPECTED_SEQUENCE_DEFINITION}"

  for command in "${commands[@]}"; do
    "${command}"
  done

  assert_array_equals expected_sequence __MOCK_SEQUENCE
}

@parametrize_with_sequence_tracking \
  test_stdlib_testing_mock_object_sequence__@vary__updates_sequence
