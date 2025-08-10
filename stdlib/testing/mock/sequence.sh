#!/bin/bash
# @file sequence.sh
# @brief A library for asserting on mock call sequences.
# @description
#   This library provides functions to assert on the sequence of mock calls.

# stdlib testing mock sequence library

set -eo pipefail

__MOCK_SEQUENCE=()

# @description Asserts that the sequence of mock calls is as expected.
# @arg $@ The expected sequence of mock calls.
_mock.sequence.assert_is() {
  # shellcheck disable=SC2034
  local MOCK_SEQUENCE=("${__MOCK_SEQUENCE[@]}")
  local EXPECTED_MOCK_SEQUENCE=()
  # shellcheck disable=SC2034

  EXPECTED_MOCK_SEQUENCE=("$@")

  _testing.__assertion.value.check "${@}"

  assert_array_equals EXPECTED_MOCK_SEQUENCE MOCK_SEQUENCE
}

# @description Asserts that the sequence of mock calls is empty.
_mock.sequence.assert_is_empty() {

  # shellcheck disable=SC2034
  local MOCK_SEQUENCE=("${__MOCK_SEQUENCE[@]}")
  # shellcheck disable=SC2034
  local EXPECTED_MOCK_SEQUENCE=()

  assert_array_equals EXPECTED_MOCK_SEQUENCE MOCK_SEQUENCE
}

# @description Clears the sequence of mock calls.
_mock.sequence.clear() {
  __MOCK_SEQUENCE=()
}
