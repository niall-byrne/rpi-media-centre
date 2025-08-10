#!/bin/bash
# @file substring.sh
# @brief A library for colourizing substrings.
# @description
#   This library provides functions to find and colourize substrings within a string.

# stdlib string colour substring library

set -eo pipefail

# @description Finds the first occurrence of a substring and colourizes it.
# @arg $1 string The colour to use.
# @arg $2 string The substring to colourize.
# @arg $3 string The source string.
# @exitcode ? Propagated from stdlib.fn.args.require.
# @stdout The string with the first occurrence of the substring colourized.
stdlib.string.colour.substring() {
  local string_colour

  stdlib.fn.args.require "3" "0" "${@}" || return "$?"

  string_colour="$(stdlib.string.colour._short_colour_to_internal_colour "${1}")"

  echo -e "${3/${2}/${!string_colour}${2}${STDLIB_COLOUR_NC}}"
}

# @description Finds all occurrences of a substring and colourizes them.
# @arg $1 string The colour to use.
# @arg $2 string The substring to colourize.
# @arg $3 string The source string.
# @exitcode ? Propagated from stdlib.fn.args.require.
# @stdout The string with all occurrences of the substring colourized.
stdlib.string.colour.substrings() {
  local string_colour

  stdlib.fn.args.require "3" "0" "${@}" || return "$?"

  string_colour="$(stdlib.string.colour._short_colour_to_internal_colour "${1}")"

  echo -e "${3//${2}/${!string_colour}${2}${STDLIB_COLOUR_NC}}"
}
