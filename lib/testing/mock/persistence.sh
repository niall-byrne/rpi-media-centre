#!/bin/bash

# pictl testing mock persistence library

set -eo pipefail

__MOCK_REGISTRY=""
__MOCK_INSTANCES=()

__mock.persistence.create() {
  # $1: the name of the mock being persisted across subshells

  printf -v "__${1}_mock_calls_file" "%s" "$(mktemp -p "${__MOCK_REGISTRY}")"
  printf -v "__${1}_mock_side_effects_file" "%s" "$(mktemp -p "${__MOCK_REGISTRY}")"
}

__mock.persistence.registry.cleanup() {
  rm -rf "${__MOCK_REGISTRY}"
}

__mock.persistence.registry.create() {
  __MOCK_REGISTRY="$(mktemp -d)"
}

__mock.persistence.registry.reset_all() {
  local _MOCK_INSTANCE

  for _MOCK_INSTANCE in "${__MOCK_INSTANCES[@]}"; do
    "${_MOCK_INSTANCE}".mock.reset
  done
}
