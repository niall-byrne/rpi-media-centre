#!/bin/bash

test_stdlib_testing_mock_persistence_create__registers_the_mock_instance() {
  __mock.persistence.create "my_mock" "my_mock_sanitized"

  stdlib.array.assert.is_contains "my_mock" "__MOCK_INSTANCES"
}

test_stdlib_testing_mock_persistence_create__creates_the_correct_persistence_files() {
  local calls_file_var="__my_mock_sanitized_mock_calls_file"
  local side_effects_file_var="__my_mock_sanitized_mock_side_effects_file"

  __mock.persistence.create "my_mock" "my_mock_sanitized"

  stdlib.io.path.assert.is_file "${!calls_file_var}"
  stdlib.io.path.assert.is_file "${!side_effects_file_var}"
}
