#!/bin/bash

# stdlib testing random fixtures

builtin set -eo pipefail

_testing.fixtures.random.name() {
  # $1: an optional length

  local random_name_length="${1:-50}"

  "${_STDLIB_BINARY_TR}" -dc A-Za-z0-9 < /dev/urandom |
    "${_STDLIB_BINARY_HEAD}" -c "${random_name_length}"
  builtin echo
}
