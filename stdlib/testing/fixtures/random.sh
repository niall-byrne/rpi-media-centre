#!/bin/bash
# @file random.sh
# @brief A library of random data fixtures for testing.
# @description
#   This library provides functions to generate random data for testing, such as random names.

# stdlib testing random fixtures

set -eo pipefail

# @description Generates a random alphanumeric string of a given length.
# @arg $1 integer (optional) The length of the random string. Defaults to 50.
# @stdout A random alphanumeric string.
_testing.fixtures.random.name() {
  local random_name_length="${1:-50}"

  tr -dc A-Za-z0-9 < /dev/urandom |
    head -c "${random_name_length}"
  echo
}
