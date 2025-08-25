#!/bin/bash

# stdlib array make library

builtin set -eo pipefail

stdlib.array.make.from_file() {
  # $1: the array name
  # $2: the separator
  # $3: the source file

  stdlib.fn.args.require "3" "0" "${@}" || return "$?"
  stdlib.io.path.assert.is_file "${3}" || return 126

  IFS="${2}" builtin read -ra "${1}" < "${3}"
}

stdlib.array.make.from_string() {
  # $1: the array name
  # $2: the separator
  # $3: the source string

  local _STDLIB_ARGS_NULL_SAFE=("3")

  stdlib.fn.args.require "3" "0" "${@}" || return "$?"

  IFS="${2}" builtin read -d "" -ra "${1}" < <(builtin echo -n "${3}") || return 0
}

stdlib.array.make.from_string_n() {
  # $1: the array name
  # $2: the count of repeats
  # $3: the string to repeat

  local _STDLIB_ARGS_NULL_SAFE=("3")
  local array_index

  stdlib.fn.args.require "3" "0" "${@}" || return "$?"
  stdlib.string.assert.is_digit "${2}" || return 126

  for ((array_index = 0; array_index < "${2}"; array_index++)); do
    builtin printf -v "${1}[${array_index}]" "%s" "${3}"
  done
}
