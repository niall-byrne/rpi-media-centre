#!/bin/bash

# stdlib testing mock sequence library

set -eo pipefail

__MOCK_SEQUENCE=()

_mock.sequence.assert_is() {
  # $@: the expected sequence of mock calls

  # shellcheck disable=SC2034
  local mock_sequence=("${__MOCK_SEQUENCE[@]}")
  local expected_mock_sequence=("$@")
  # shellcheck disable=SC2034

  _testing.__assertion.value.check "${@}"

  assert_array_equals expected_mock_sequence mock_sequence
}

_mock.sequence.assert_is_empty() {

  # shellcheck disable=SC2034
  local mock_sequence=("${__MOCK_SEQUENCE[@]}")
  # shellcheck disable=SC2034
  local expected_mock_sequence=()

  assert_array_equals expected_mock_sequence mock_sequence
}

_mock.sequence.clear() {
  __MOCK_SEQUENCE=()
}
