#!/bin/bash

# stdlib testing debug fixtures

builtin set -eo pipefail

_testing.fixtures.debug.diff() {
  # $1: the expected value to compare against
  # $2: the actual value to compare with

  local debug_colour

  debug_colour="$(stdlib.setting.theme.get_colour "${STDLIB_TESTING_THEME_DEBUG_FIXTURE}")"

  # shellcheck disable=SC2059
  builtin printf "%s\n" "$(_testing.message.get DEBUG_DIFF_HEADER)"
  builtin printf "${!debug_colour}%s${STDLIB_COLOUR_NC}\n%q\n" "$(_testing.message.get DEBUG_DIFF_PREFIX_EXPECTED):" "${1}"
  # shellcheck disable=SC2059
  builtin printf "${!debug_colour}%s${STDLIB_COLOUR_NC}\n%q\n" "$(_testing.message.get DEBUG_DIFF_PREFIX_ACTUAL):" "${2}"
  builtin printf "${!debug_colour}%s${STDLIB_COLOUR_NC}\n" "$(_testing.message.get DEBUG_DIFF_PREFIX):"
  # shellcheck disable=SC2059
  diff <(builtin printf "%s" "${1}") <(builtin printf "%s" "${2}")
  builtin printf "%s\n" "$(_testing.message.get DEBUG_DIFF_FOOTER)"
}
