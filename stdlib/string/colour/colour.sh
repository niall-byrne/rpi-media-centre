#!/bin/bash
# shellcheck disable=SC2034

# stdlib string colour library

set -eo pipefail

stdlib.string.colour_n() {
  # $1: the colour
  # $2: the source string

  local string_colour

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"

  string_colour="$(stdlib.string.colour._short_colour_to_internal_colour "${1}")"

  echo -ne "${!string_colour}${2}${STDLIB_COLOUR_NC}"
}

stdlib.string.colour() {
  # $1: the colour
  # $2: the source string

  local string_output

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"

  string_output="$(stdlib.string.colour_n "${1}" "${2}")"

  echo -e "${string_output}"
}
