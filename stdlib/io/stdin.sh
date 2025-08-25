#!/bin/bash

# stdlib io stdin library

builtin set -eo pipefail

_STDLIB_PASSWORD_BOOLEAN=""

stdlib.io.stdin.confirmation() {
  # 1: (optional) the prompt to display

  local input_char
  local prompt=${1:-"$(stdlib.message.get STDIN_DEFAULT_CONFIRMATION_PROMPT)"}

  stdlib.fn.args.require "0" "1" "${@}" || return "$?"

  builtin echo -en "${prompt}"

  while builtin true; do
    builtin read -rs -n 1 input_char
    if [[ "${input_char}" == "n" ]]; then
      builtin echo
      return 1
    fi
    if [[ "${input_char}" == "Y" ]]; then
      builtin echo
      return 0
    fi
  done
}

stdlib.io.stdin.pause() {
  # 1: (optional) the prompt to display

  local input_char
  local prompt=${1:-"$(stdlib.message.get STDIN_DEFAULT_PAUSE_PROMPT)"}

  stdlib.fn.args.require "0" "1" "${@}" || return "$?"

  builtin echo -en "${prompt}"
  builtin read -rs -n 1 input_char
}

stdlib.io.stdin.prompt() {
  # 1: the variable name to save
  # 2: (optional) the prompt to display
  #
  # _STDLIB_PASSWORD_BOOLEAN: set to 1 to mask password entry

  local flags="-rp"
  local prompt=${2:-"$(stdlib.message.get STDIN_DEFAULT_VALUE_PROMPT)"}
  local password="${_STDLIB_PASSWORD_BOOLEAN:-0}"

  stdlib.fn.args.require "1" "1" "${@}" || return "$?"

  if [[ "${password}" == "1" ]]; then
    flags="-rsp"
  fi

  while [[ -z "${!1}" ]]; do
    # shellcheck disable=SC2229,SC2162
    stdlib.builtin.overridable read "${flags}" "${prompt}" "${1}"
    if [[ "${password}" == "1" ]]; then
      stdlib.builtin.overridable echo
    fi
  done
}
