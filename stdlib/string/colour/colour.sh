#!/bin/bash
# shellcheck disable=SC2034

# stdlib string colour library

builtin set -eo pipefail

stdlib.string.colour_n() {
  # $1: the colour
  # $2: the source string

  local _STDLIB_ARGS_NULL_SAFE=("2")
  local string_colour

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"

  string_colour="$(stdlib.setting.theme.get_colour "${1}")"

  builtin echo -ne "${!string_colour}${2}${STDLIB_COLOUR_NC}"
}

stdlib.string.colour() {
  # $1: the colour
  # $2: the source string

  local _STDLIB_ARGS_NULL_SAFE=("2")
  local string_output

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"

  string_output="$(stdlib.string.colour_n "${1}" "${2}")"

  builtin echo -e "${string_output}"
}
