#!/bin/bash
# @file logger.sh
# @brief A library of logger fixtures for testing.
# @description
#   This library provides a fixture to mock the logger functions for testing.

# stdlib testing logger fixtures

set -eo pipefail

# @description Mocks all the logger functions.
# This function uses the `_mock.create` function to mock all the functions in the `stdlib.logger` module.
_testing.fixtures.mock.logger() {
  _mock.create stdlib.logger.error
  _mock.create stdlib.logger.warning
  _mock.create stdlib.logger.info
  _mock.create stdlib.logger.notice
  _mock.create stdlib.logger.success
}
