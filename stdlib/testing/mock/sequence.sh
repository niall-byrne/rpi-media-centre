#!/bin/bash

# stdlib testing mock sequence library

set -eo pipefail

__MOCK_SEQUENCE=()

_mock.sequence.assert_is() {
  # $@: the expected sequence of mock calls

  # shellcheck disable=SC2034
  local MOCK_SEQUENCE=("${__MOCK_SEQUENCE[@]}")
  local EXPECTED_MOCK_SEQUENCE=()
  # shellcheck disable=SC2034

  EXPECTED_MOCK_SEQUENCE=("$@")

  _testing.__assertion.value.check "${@}"

  assert_array_equals EXPECTED_MOCK_SEQUENCE MOCK_SEQUENCE
}

_mock.sequence.assert_is_empty() {

  # shellcheck disable=SC2034
  local MOCK_SEQUENCE=("${__MOCK_SEQUENCE[@]}")
  # shellcheck disable=SC2034
  local EXPECTED_MOCK_SEQUENCE=()

  assert_array_equals EXPECTED_MOCK_SEQUENCE MOCK_SEQUENCE
}

_mock.sequence.clear() {
  __MOCK_SEQUENCE=()
}
