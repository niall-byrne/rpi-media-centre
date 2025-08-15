#!/bin/bash

# stdlib testing mock persistence library

set -eo pipefail

__MOCK_REGISTRY=""
__MOCK_INSTANCES=()

__mock.persistence.create() {
  # $1: the name of the mock being persisted across subshells
  # $1: the sanitized name of the mock being persisted across subshells

  __MOCK_INSTANCES+=("${1}")
  printf -v "__${2}_mock_calls_file" "%s" "$(mktemp -p "${__MOCK_REGISTRY}")"
  printf -v "__${2}_mock_side_effects_file" "%s" "$(mktemp -p "${__MOCK_REGISTRY}")"
}

__mock.persistence.registry.apply_to_all() {
  # $1: the command to execute on all registered mocks

  local mock_instance

  for mock_instance in "${__MOCK_INSTANCES[@]}"; do
    "${mock_instance}".mock."${1}"
  done
}

__mock.persistence.registry.cleanup() {
  rm -rf "${__MOCK_REGISTRY}"
}

__mock.persistence.registry.create() {
  __MOCK_REGISTRY="$(mktemp -d)"
}
