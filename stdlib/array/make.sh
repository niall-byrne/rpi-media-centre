#!/bin/bash
# @file make.sh
# @brief A library for creating arrays.
# @description
#   This library provides functions to create arrays from different sources,
#   such as files, strings, or by repeating a string.

# stdlib array make library

set -eo pipefail

# @description Creates an array from the content of a file.
# The file content is split by the provided separator.
# @arg $1 string The name of the array to create.
# @arg $2 string The separator to use for splitting.
# @arg $3 string The path to the source file.
# @exitcode 126 If wrong or invalid arguments have been passed.
# @exitcode ? Propagated from stdlib.fn.args.require.
stdlib.array.make.from_file() {
  stdlib.fn.args.require "3" "0" "${@}" || return "$?"
  stdlib.io.filesystem.assert.is_file "${3}" || return 126

  IFS="${2}" read -ra "${1}" < "${3}"
}

# @description Creates an array from a string.
# The string is split by the provided separator.
# @arg $1 string The name of the array to create.
# @arg $2 string The separator to use for splitting.
# @arg $3 string The source string.
# @exitcode ? Propagated from stdlib.fn.args.require.
stdlib.array.make.from_string() {
  stdlib.fn.args.require "3" "0" "${@}" || return "$?"

  IFS="${2}" read -ra "${1}" <<< "${3}"
}

# @description Creates an array with N elements, each containing the same string.
# @arg $1 string The name of the array to create.
# @arg $2 integer The number of elements in the array.
# @arg $3 string The string to fill the array with.
# @exitcode 126 If wrong or invalid arguments have been passed.
# @exitcode ? Propagated from stdlib.fn.args.require.
stdlib.array.make.from_string_n() {
  local array_index

  stdlib.fn.args.require "3" "0" "${@}" || return "$?"
  stdlib.string.assert.is_digit "${2}" || return 126

  for ((array_index = 0; array_index < "${2}"; array_index++)); do
    printf -v "${1}[${array_index}]" "%s" "${3}"
  done
}
