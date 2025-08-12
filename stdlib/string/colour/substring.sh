#!/bin/bash

# stdlib string colour substring library

set -eo pipefail

stdlib.string.colour.substring() {
  # $1: the colour
  # $2: the substring to colour
  # $3: the source string

  local _ARGS_NULL_SAFE=("2" "3")
  local string_colour

  stdlib.fn.args.require "3" "0" "${@}" || return "$?"

  string_colour="$(stdlib.string.colour._short_colour_to_internal_colour "${1}")"

  echo -e "${3/${2}/${!string_colour}${2}${STDLIB_COLOUR_NC}}"
}

stdlib.string.colour.substrings() {
  # $1: the colour
  # $2: the substring to colour
  # $3: the source string

  local _ARGS_NULL_SAFE=("2" "3")
  local string_colour

  stdlib.fn.args.require "3" "0" "${@}" || return "$?"

  string_colour="$(stdlib.string.colour._short_colour_to_internal_colour "${1}")"

  echo -e "${3//${2}/${!string_colour}${2}${STDLIB_COLOUR_NC}}"
}
