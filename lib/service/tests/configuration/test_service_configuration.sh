#!/bin/bash

setup() {
  _mock.create _service_query_is_selected
  _mock.create _configuration_service_mock_service_1
  _mock.create _configuration_service_mock_service_2
  _mock.create _configuration_service_mock_service_3
}

@parametrize_with_mock_services() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_IS_SELECTED_SIDE_EFFECTS_DEFINITION;TEST_EXPECTED_SEQUENCE_DEFINITION" \
    "service_1_____service_2_____service_3_____;return 0|return 0|return 0;_service_query_is_selected|_configuration_service_mock_service_1|_service_query_is_selected|_configuration_service_mock_service_2|_service_query_is_selected|_configuration_service_mock_service_3" \
    "service_1_____service_2_____no_service_3__;return 0|return 0|return 1;_service_query_is_selected|_configuration_service_mock_service_1|_service_query_is_selected|_configuration_service_mock_service_2|_service_query_is_selected" \
    "service_1_____no_service_2__service_3_____;return 0|return 1|return 0;_service_query_is_selected|_configuration_service_mock_service_1|_service_query_is_selected|_service_query_is_selected|_configuration_service_mock_service_3" \
    "service_1_____no_service_2__no_service_3__;return 0|return 1|return 1;_service_query_is_selected|_configuration_service_mock_service_1|_service_query_is_selected|_service_query_is_selected" \
    "no_service_1__service_2_____no_service_3__;return 1|return 0|return 1;_service_query_is_selected|_service_query_is_selected|_configuration_service_mock_service_2|_service_query_is_selected" \
    "no_service_1__service_2_____service_3_____;return 1|return 0|return 0;_service_query_is_selected|_service_query_is_selected|_configuration_service_mock_service_2|_service_query_is_selected|_configuration_service_mock_service_3" \
    "no_service_1__no_service_2__service_3_____;return 1|return 1|return 0;_service_query_is_selected|_service_query_is_selected|_service_query_is_selected|_configuration_service_mock_service_3" \
    "no_service_1__no_service_2__no_service_3__;return 1|return 1|return 1;_service_query_is_selected|_service_query_is_selected|_service_query_is_selected"
}

_is_service_mock() {
  # $1: the mock name to test

  stdlib.string.query.starts_with "_configuration_service_" "${1}"
}

test_service_configuration__@vary__configures_expected_services() {
  local expected_sequence
  local side_effects

  stdlib.array.make.from_string side_effects "|" "${TEST_IS_SELECTED_SIDE_EFFECTS_DEFINITION}"
  stdlib.array.make.from_string expected_sequence "|" "${TEST_EXPECTED_SEQUENCE_DEFINITION}"
  _service_query_is_selected.mock.set.side_effects "${side_effects[@]}"
  _mock.sequence.record.start

  _service_configuration "mock_service_1" "mock_service_2" "mock_service_3"

  _mock.sequence.assert_is \
    "${expected_sequence[@]}"
}

@parametrize_with_mock_services \
  test_service_configuration__@vary__configures_expected_services

test_service_configuration__@vary__configures_each_service_correctly() {
  local mock_sequence
  local service_name
  local side_effects

  stdlib.array.make.from_string side_effects "|" "${TEST_IS_SELECTED_SIDE_EFFECTS_DEFINITION}"
  stdlib.array.make.from_string mock_sequence "|" "${TEST_EXPECTED_SEQUENCE_DEFINITION}"
  stdlib.array.mutate.filter _is_service_mock mock_sequence
  _service_query_is_selected.mock.set.side_effects "${side_effects[@]}"

  _service_configuration "mock_service_1" "mock_service_2" "mock_service_3"

  for service_name in "${mock_sequence[@]}"; do
    "${service_name}.mock.assert_called_once_with" ""
  done
}

@parametrize_with_mock_services \
  test_service_configuration__@vary__configures_each_service_correctly
