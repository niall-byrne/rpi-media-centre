#!/bin/bash
# @file has.sh
# @brief A library for querying strings for the presence of substrings.
# @description
#   This library provides functions to query strings for the presence of substrings or characters.

# stdlib string query has library

set -eo pipefail

# @description Checks if a character is present at a specific index in a string.
# @arg $1 string The character to check for.
# @arg $2 integer The index to check at.
# @arg $3 string The string to check.
# @exitcode 0 If the character is present at the index.
# @exitcode 1 If the character is not present at the index.
# @exitcode 126 If an argument is empty or invalid.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @exitcode ? Propagated from stdlib.string.query.is_char and stdlib.string.query.is_digit.
stdlib.string.query.has_char_n() {
  [[ "${#@}" == "3" ]] || return 127
  stdlib.string.query.is_char "${1}" || return "$?"
  stdlib.string.query.is_digit "${2}" || return "$?"
  [[ -n "${3}" ]] || return 126

  [[ "${1}" != "${3:${2}:1}" ]] && return 1
  return 0
}

# @description Checks if a string contains a substring.
# @arg $1 string The substring to check for.
# @arg $2 string The string to check.
# @exitcode 0 If the substring is present.
# @exitcode 1 If the substring is not present.
# @exitcode 126 If an argument is empty.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.string.query.has_substring() {
  [[ "${#@}" == "2" ]] || return 127
  [[ -n "${1}" ]] || return 126
  [[ -n "${2}" ]] || return 126

  [[ "${2}" != *"${1}"* ]] && return 1
  return 0
}
