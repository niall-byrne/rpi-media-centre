#!/bin/bash
# @file sugar.sh
# @brief A library of syntactic sugar for string queries.
# @description
#   This library provides syntactic sugar functions for common string queries,
#   such as checking if a string starts or ends with a specific substring.

# stdlib string query syntactic sugar library

set -eo pipefail

# @description Checks if a string ends with a specific substring.
# @arg $1 string The substring to check for.
# @arg $2 string The string to check.
# @exitcode 0 If the string ends with the substring.
# @exitcode 1 If the string does not end with the substring.
# @exitcode 126 If an argument is empty.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.string.query.ends_with() {
  [[ "${#@}" == "2" ]] || return 127
  [[ -n "${1}" ]] || return 126
  [[ -n "${2}" ]] || return 126

  [[ "${2}" == *"${1}" ]] || return 1
  return 0
}

# @description Checks if the first character of a string is a specific character.
# @arg $1 string The character to check for.
# @arg $2 string The string to check.
# @exitcode 0 If the first character matches.
# @exitcode 1 If the first character does not match.
# @exitcode 126 If an argument is empty or if the first argument is not a single character.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.string.query.first_char_is() {
  [[ "${#@}" == "2" ]] || return 127
  [[ "${#1}" == "1" ]] || return 126
  [[ -n "${2}" ]] || return 126

  stdlib.string.query.has_char_n "${1}" "0" "${2}"
}

# @description Checks if the last character of a string is a specific character.
# @arg $1 string The character to check for.
# @arg $2 string The string to check.
# @exitcode 0 If the last character matches.
# @exitcode 1 If the last character does not match.
# @exitcode 126 If an argument is empty or if the first argument is not a single character.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.string.query.last_char_is() {
  [[ "${#@}" == "2" ]] || return 127
  [[ "${#1}" == "1" ]] || return 126
  [[ -n "${2}" ]] || return 126

  stdlib.string.query.has_char_n "${1}" "$(("${#2}" - 1))" "${2}"
}

# @description Checks if a string starts with a specific substring.
# @arg $1 string The substring to check for.
# @arg $2 string The string to check.
# @exitcode 0 If the string starts with the substring.
# @exitcode 1 If the string does not start with the substring.
# @exitcode 126 If an argument is empty.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.string.query.starts_with() {
  [[ "${#@}" == "2" ]] || return 127
  [[ -n "${1}" ]] || return 126
  [[ -n "${2}" ]] || return 126

  [[ "${2}" == "${1}"* ]] || return 1
  return 0
}
