#!/bin/bash

# stdlib testing mock sequence library

builtin set -eo pipefail

__MOCK_SEQUENCE=()

_mock.sequence.assert_is() {
  # $@: the expected sequence of mock calls

  local mock_sequence=()
  local expected_mock_sequence=("$@")
  # shellcheck disable=SC2034

  _testing.__assertion.value.check "${@}"

  _mock.sequence.record.stop

  __mock.persistence.sequence.retrieve
  mock_sequence=("${__MOCK_SEQUENCE[@]}")

  assert_array_equals expected_mock_sequence mock_sequence
}

_mock.sequence.assert_is_empty() {

  local mock_sequence=()
  # shellcheck disable=SC2034
  local expected_mock_sequence=()

  _mock.sequence.record.stop

  __mock.persistence.sequence.retrieve
  # shellcheck disable=SC2034
  mock_sequence=("${__MOCK_SEQUENCE[@]}")

  assert_array_equals expected_mock_sequence mock_sequence
}

_mock.sequence.clear() {
  __mock.persistence.sequence.clear
}

_mock.sequence.record.start() {
  __mock.persistence.sequence.clear
  __MOCK_SEQUENCE_TRACKING="1"
}

_mock.sequence.record.stop() {
  __MOCK_SEQUENCE_TRACKING="0"
}

_mock.sequence.record.resume() {
  __MOCK_SEQUENCE_TRACKING="1"
}
