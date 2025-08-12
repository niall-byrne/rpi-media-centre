#!/bin/bash

# stdlib string map library

set -eo pipefail

stdlib.string.map.format() {
  # $1: a valid print format string to apply to each line
  # $2: the input string to process
  #
  # _DELIMITER:  a char sequence to split the string with for processing

  local _ARGS_NULL_SAFE=("2")
  local delimiter="${_DELIMITER:-$'\n'}"
  local line=""
  local output=""

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"

  if ! stdlib.string.query.has_substring "${delimiter}" "${2}"; then
    # shellcheck disable=SC2059
    printf "${1}" "${2}"
    echo
    return
  fi

  while IFS="${delimiter}" read -r -d "${delimiter}" line; do
    # shellcheck disable=SC2059
    output+="$(printf "${1}" "${line}")${delimiter}"
  done < <(echo -n "${2}${delimiter}")

  echo -e "${output%?}"
}

stdlib.fn.derive.pipeable "stdlib.string.map.format" "2"

stdlib.fn.derive.var "stdlib.string.map.format"

stdlib.string.map.fn() {
  # $1: a valid function apply to each line
  # $2: the input string to process
  #
  # _DELIMITER:  a char sequence to split the string with for processing

  local _ARGS_NULL_SAFE=("2")
  local delimiter="${_DELIMITER:-$'\n'}"
  local line=""
  local output=""

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"
  stdlib.fn.assert.is_fn "${1}" || return 126

  if ! stdlib.string.query.has_substring "${delimiter}" "${2}"; then
    "${1}" "${2}"
    return
  fi

  while IFS="${delimiter}" read -r -d "${delimiter}" line; do
    output+="$("${1}" "${line}")${delimiter}"
  done < <(echo -n "${2}${delimiter}")

  echo -e "${output%?}"
}

stdlib.fn.derive.pipeable "stdlib.string.map.fn" "2"

stdlib.fn.derive.var "stdlib.string.map.fn"
