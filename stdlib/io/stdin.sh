#!/bin/bash

# stdlib io stdin library

set -eo pipefail

stdlib.io.stdin.confirmation() {
  # 1: (optional) the prompt to display

  local input_char
  local prompt=${1:-"Are you sure you wish to proceed (Y/n) ? "}

  stdlib.fn.args.require "0" "1" "${@}" || return "$?"

  echo -en "${prompt}"

  while true; do
    read -rs -n 1 input_char
    if [[ "${input_char}" == "n" ]]; then
      echo ""
      return 1
    fi
    if [[ "${input_char}" == "Y" ]]; then
      echo ""
      return 0
    fi
  done
}

stdlib.io.stdin.pause() {
  # 1: (optional) the prompt to display

  local input_char
  local prompt=${1:-"Press any key to continue ... "}

  stdlib.fn.args.require "0" "1" "${@}" || return "$?"

  echo -en "${prompt}"
  read -rs -n 1 input_char
}

stdlib.io.stdin.prompt() {
  # 1: the variable name to save
  # 2: (optional) the prompt to display
  # 3: (optional) set to "password" to suppress output

  local flags="-rp"
  local prompt=${2:-"Enter a value: "}

  stdlib.fn.args.require "1" "2" "${@}" || return "$?"

  if [[ "${3}" == "password" ]]; then
    flags="-rsp"
  fi

  while [[ -z "${!1}" ]]; do
    # shellcheck disable=SC2229,SC2162
    read "${flags}" "${prompt}" "${1}"
    if [[ "${3}" == "password" ]]; then
      echo
    fi
  done
}
