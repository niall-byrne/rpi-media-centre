#!/bin/bash
# @file colour.sh
# @brief A library for adding colour to strings.
# @description
#   This library provides functions to add ANSI colour codes to strings.

# shellcheck disable=SC2034

# stdlib string colour library

set -eo pipefail

# @description Prints a string in a given colour, without a trailing newline.
# @arg $1 string The colour to use.
# @arg $2 string The string to colourize.
# @exitcode ? Propagated from stdlib.fn.args.require.
# @stdout The colourized string.
stdlib.string.colour_n() {
  local string_colour

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"

  string_colour="$(stdlib.string.colour._short_colour_to_internal_colour "${1}")"

  echo -ne "${!string_colour}${2}${STDLIB_COLOUR_NC}"
}

# @description Prints a string in a given colour, with a trailing newline.
# @arg $1 string The colour to use.
# @arg $2 string The string to colourize.
# @exitcode ? Propagated from stdlib.fn.args.require.
# @stdout The colourized string.
stdlib.string.colour() {
  local string_output

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"

  string_output="$(stdlib.string.colour_n "${1}" "${2}")"

  echo -e "${string_output}"
}
