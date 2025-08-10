#!/bin/bash
# @file stdin.sh
# @brief A library for interacting with stdin.
# @description
#   This library provides functions for interacting with the user via stdin,
#   such as asking for confirmation, pausing the script, or prompting for input.

# stdlib io stdin library

set -eo pipefail

# @description Asks the user for confirmation.
# @arg $1 string (optional) The prompt to display. Defaults to "Are you sure you wish to proceed (Y/n) ? ".
# @exitcode 0 If the user confirms (Y).
# @exitcode 1 If the user denies (n).
# @exitcode 126 If an argument is null when not allowed.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @stdout The confirmation prompt.
stdlib.io.stdin.confirmation() {
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

# @description Pauses the script and waits for the user to press any key.
# @arg $1 string (optional) The prompt to display. Defaults to "Press any key to continue ... ".
# @exitcode 126 If an argument is null when not allowed.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @stdout The pause prompt.
stdlib.io.stdin.pause() {
  local input_char
  local prompt=${1:-"Press any key to continue ... "}

  stdlib.fn.args.require "0" "1" "${@}" || return "$?"

  echo -en "${prompt}"
  read -rs -n 1 input_char
}

# @description Prompts the user for input and saves it to a variable.
# @arg $1 string The name of the variable to save the input to.
# @arg $2 string (optional) The prompt to display. Defaults to "Enter a value: ".
# @arg $3 string (optional) If set to "password", the user's input will be hidden.
# @exitcode 126 If an argument is null when not allowed.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @stdout The input prompt.
stdlib.io.stdin.prompt() {
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
