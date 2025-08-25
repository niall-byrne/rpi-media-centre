#!/bin/bash

setup() {
  _mock.create mktemp
  mktemp.mock.set.stdout "mocked_temp_directory"
}

test_stdlib_testing_mock_persistence_registry_create__calls_mktemp_as_expected() {
  local __MOCK_REGISTRY=""

  _STDLIB_BINARY_MKTEMP="mktemp" \
    __mock.persistence.registry.create

  mktemp.mock.assert_called_once_with "1(-d)"
}

test_stdlib_testing_mock_persistence_registry_create__sets_registry_variable() {
  local __MOCK_REGISTRY=""

  _STDLIB_BINARY_MKTEMP="mktemp" \
    __mock.persistence.registry.create

  assert_equals "${__MOCK_REGISTRY}" "mocked_temp_directory"
}
