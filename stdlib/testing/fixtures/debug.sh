#!/bin/bash

# stdlib testing debug fixtures

set -eo pipefail

_testing.fixtures.debug.diff() {
  # $1: the expected value to compare against
  # $2: the actual value to compare with

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
