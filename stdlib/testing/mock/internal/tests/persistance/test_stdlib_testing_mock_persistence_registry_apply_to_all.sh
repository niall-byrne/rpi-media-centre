#!/bin/bash

mock1.mock.mock_command() {
  echo "command 1"
}

mock2.mock.mock_command() {
  echo "command 2"
}

test_stdlib_testing_mock_persistence_registry_apply_to_all__no_mocks__is_not_applied() {
  local __MOCK_INSTANCES=()

  _capture.stdout __mock.persistence.registry.apply_to_all "mock_command"

  assert_output_null
}

test_stdlib_testing_mock_persistence_registry_apply_to_all__two_mocks__applies_to_both() {
  local __MOCK_INSTANCES=("mock1" "mock2")

  _capture.stdout __mock.persistence.registry.apply_to_all "mock_command"

  assert_output "command 1"$'\n'"command 2"
}
