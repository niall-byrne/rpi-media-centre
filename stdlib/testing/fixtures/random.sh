#!/bin/bash

# stdlib testing random fixtures

set -eo pipefail

_testing.fixtures.random.name() {
  # $1: an optional length

  local random_name_length="${1:-50}"

  tr -dc A-Za-z0-9 < /dev/urandom |
    head -c "${random_name_length}"
  echo
}
