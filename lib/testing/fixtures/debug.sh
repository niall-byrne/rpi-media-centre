#!/bin/bash

# pictl testing debug fixtures

set -eo pipefail

_debug_with_diff() {
  # shellcheck disable=SC2059
  echo -e "  ${COLOUR_GRAY}TEST_EXPECTED:${COLOUR_NC}\n$(printf "${TEST_FORMAT}" "${TEST_EXPECTED}")"
  # shellcheck disable=SC2059
  echo -e "  ${COLOUR_GRAY}TEST_INPUT:${COLOUR_NC}   \n$(printf "${TEST_FORMAT}" "${TEST_INPUT}")"
  # shellcheck disable=SC2059
  echo -e "  ${COLOUR_GRAY}TEST_OUTPUT:${COLOUR_NC}  \n$(printf "${TEST_FORMAT}" "${TEST_OUTPUT}")"

  # shellcheck disable=SC2059
  diff <(printf "${TEST_FORMAT}" "${TEST_EXPECTED}") <(printf "${TEST_FORMAT}" "${TEST_OUTPUT}")
}

_debug_with_colour() {
  _io_colours_load "1"

  echo -e "${TEST_OUTPUT}"
}
