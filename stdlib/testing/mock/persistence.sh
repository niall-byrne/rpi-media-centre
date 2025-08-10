#!/bin/bash
# @file persistence.sh
# @brief A library for mock persistence.
# @description
#   This library provides functions for managing the persistence of mock data across subshells.
#   This is achieved by storing mock data in temporary files.

# stdlib testing mock persistence library

set -eo pipefail

__MOCK_REGISTRY=""
__MOCK_INSTANCES=()

# @description Creates the persistence files for a mock.
# This is an internal function.
# @arg $1 string The name of the mock.
# @arg $2 string The sanitized name of the mock.
__mock.persistence.create() {
  __MOCK_INSTANCES+=("${1}")
  printf -v "__${2}_mock_calls_file" "%s" "$(mktemp -p "${__MOCK_REGISTRY}")"
  printf -v "__${2}_mock_side_effects_file" "%s" "$(mktemp -p "${__MOCK_REGISTRY}")"
}

# @description Applies a command to all registered mocks.
# This is an internal function.
# @arg $1 string The command to execute on all mocks (e.g. 'clear', 'reset').
__mock.persistence.registry.apply_to_all() {
  local _MOCK_INSTANCE

  for _MOCK_INSTANCE in "${__MOCK_INSTANCES[@]}"; do
    "${_MOCK_INSTANCE}".mock."${1}"
  done
}

# @description Cleans up the mock registry by removing the temporary directory.
# This is an internal function.
__mock.persistence.registry.cleanup() {
  rm -rf "${__MOCK_REGISTRY}"
}

# @description Creates the mock registry, which is a temporary directory to store mock data.
# This is an internal function.
__mock.persistence.registry.create() {
  __MOCK_REGISTRY="$(mktemp -d)"
}
