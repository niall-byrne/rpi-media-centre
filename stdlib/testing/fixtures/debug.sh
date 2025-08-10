#!/bin/bash
# @file debug.sh
# @brief A library of debug fixtures for testing.
# @description
#   This library provides debug fixtures for testing, such as a diff function.

# stdlib testing debug fixtures

set -eo pipefail

# @description Prints a diff between two values for debugging purposes.
# @arg $1 string The expected value to compare against.
# @arg $2 string The actual value to compare with.
# @stdout A formatted diff of the two values.
_testing.fixtures.debug.diff() {
  # shellcheck disable=SC2059
  echo "== Start Debug Diff =="
  echo -e "${STDLIB_COLOUR_GREY}EXPECTED:${STDLIB_COLOUR_NC}\n$(printf "%q" "${1}")"
  # shellcheck disable=SC2059
  echo -e "${STDLIB_COLOUR_GREY}ACTUAL:${STDLIB_COLOUR_NC}\n$(printf "%q" "${2}")"
  echo -e "${STDLIB_COLOUR_GREY}DIFF:${STDLIB_COLOUR_NC}"
  # shellcheck disable=SC2059
  diff <(printf "%s" "${1}") <(printf "%s" "${2}")
  echo "== End Debug Diff =="
}
