#!/bin/bash

# pictl testing random fixtures

set -eo pipefail

_fixture_random_name() {
  # $1: an optional length

  local _TEST_FIXTURE_RANDOM_NAME_LENGTH="${1:-50}"

  tr -dc A-Za-z0-9 < /dev/urandom |
    head -c "${_TEST_FIXTURE_RANDOM_NAME_LENGTH}"
  echo
}
