#!/bin/bash

test_stdlib_testing_mock_persistence_registry_cleanup__calls_rm_as_expected() {
  _mock.create rm

  _STDLIB_BINARY_RM="rm" __MOCK_REGISTRY="test_registry" \
    __mock.persistence.registry.cleanup

  rm.mock.assert_called_once_with "1(-rf) 2(test_registry)"
}
