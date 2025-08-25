#!/bin/bash

# stdlib testing mock internal persistence library

builtin set -eo pipefail

__MOCK_REGISTRY=""
__MOCK_INSTANCES=()
__MOCK_SEQUENCE_PERSISTENCE_FILE=""

__mock.persistence.create() {
  # $1: the name of the mock being persisted across subshells
  # $1: the sanitized name of the mock being persisted across subshells

  __MOCK_INSTANCES+=("${1}")
  builtin printf -v "__${2}_mock_calls_file" "%s" "$("${_STDLIB_BINARY_MKTEMP}" -p "${__MOCK_REGISTRY}")"
  builtin printf -v "__${2}_mock_side_effects_file" "%s" "$("${_STDLIB_BINARY_MKTEMP}" -p "${__MOCK_REGISTRY}")"
}

__mock.persistence.registry.apply_to_all() {
  # $1: the command to execute on all registered mocks (# noqa)

  local mock_instance

  for mock_instance in "${__MOCK_INSTANCES[@]}"; do
    "${mock_instance}".mock."${1}"
  done
}

__mock.persistence.registry.cleanup() {
  "${_STDLIB_BINARY_RM}" -rf "${__MOCK_REGISTRY}"
}

__mock.persistence.registry.create() {
  if [[ -z "${__MOCK_REGISTRY}" ]]; then
    __MOCK_REGISTRY="$("${_STDLIB_BINARY_MKTEMP}" -d)"
  fi
}

__mock.persistence.sequence.clear() {
  __MOCK_SEQUENCE=()
  __mock.persistence.sequence.update
}

__mock.persistence.sequence.initialize() {
  if [[ -z "${__MOCK_SEQUENCE_PERSISTENCE_FILE}" ]]; then
    __MOCK_SEQUENCE_PERSISTENCE_FILE="$("${_STDLIB_BINARY_MKTEMP}" -p "${__MOCK_REGISTRY}")"
    __mock.persistence.sequence.update
  fi
}

__mock.persistence.sequence.retrieve() {
  local __MOCK_SEQUENCE_PERSISTED_ARRAY=()

  builtin eval "$(cat "${__MOCK_SEQUENCE_PERSISTENCE_FILE}")"
  __MOCK_SEQUENCE=("${__MOCK_SEQUENCE_PERSISTED_ARRAY[@]}")
}

__mock.persistence.sequence.update() {
  local __MOCK_SEQUENCE_PERSISTED_ARRAY=("${__MOCK_SEQUENCE[@]}")

  builtin declare -p __MOCK_SEQUENCE_PERSISTED_ARRAY > "${__MOCK_SEQUENCE_PERSISTENCE_FILE}"
}
