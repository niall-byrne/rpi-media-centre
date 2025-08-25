#!/bin/bash

# stdlib string map library

builtin set -eo pipefail

stdlib.string.lines.map.format() {
  # $1: a valid print format string to apply to each line
  # $2: the input string to process
  #
  # _STDLIB_DELIMITER:  a char sequence to split the string with for processing

  local _STDLIB_ARGS_NULL_SAFE=("2")
  local delimiter="${_STDLIB_DELIMITER:-$'\n'}"
  local line=""
  local output=""

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"

  if ! stdlib.string.query.has_substring "${delimiter}" "${2}"; then
    # shellcheck disable=SC2059
    builtin printf "${1}" "${2}"
    return
  fi

  while IFS="${delimiter}" builtin read -r -d "${delimiter}" line; do
    # shellcheck disable=SC2059
    output+="$(builtin printf "${1}" "${line}")${delimiter}"
  done < <(builtin echo -n "${2}${delimiter}") # KCOV_EXCLUDE_LINE

  builtin echo -e "${output%?}"
}

stdlib.fn.derive.pipeable "stdlib.string.lines.map.format" "2"

stdlib.fn.derive.var "stdlib.string.lines.map.format"

stdlib.string.lines.map.fn() {
  # $1: a valid function apply to each line
  # $2: the input string to process
  #
  # _STDLIB_DELIMITER:  a char sequence to split the string with for processing

  local _STDLIB_ARGS_NULL_SAFE=("2")
  local delimiter="${_STDLIB_DELIMITER:-$'\n'}"
  local line=""
  local output=""

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"
  stdlib.fn.assert.is_fn "${1}" || return 126

  if ! stdlib.string.query.has_substring "${delimiter}" "${2}"; then
    "${1}" "${2}"
    return
  fi

  while IFS="${delimiter}" builtin read -r -d "${delimiter}" line; do
    output+="$("${1}" "${line}")${delimiter}"
  done < <(builtin echo -n "${2}${delimiter}") # KCOV_EXCLUDE_LINE

  builtin echo -e "${output%?}"
}

stdlib.fn.derive.pipeable "stdlib.string.lines.map.fn" "2"

stdlib.fn.derive.var "stdlib.string.lines.map.fn"
