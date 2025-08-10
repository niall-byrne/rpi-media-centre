#!/bin/bash
# @file is.sh
# @brief A library for querying string properties.
# @description
#   This library provides functions to query various properties of strings.

# stdlib string query is library

set -eo pipefail

# @description Checks if a string contains only alphabetic characters.
# @arg $1 string The string to check.
# @exitcode 0 If the string is alphabetic.
# @exitcode 1 If the string is not alphabetic.
# @exitcode 126 If the string is empty.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.string.query.is_alpha() {
  [[ "${#@}" == "1" ]] || return 127
  case "${1}" in
    "")
      return 126
      ;;
    *[![:alpha:]]*)
      return 1
      ;;
    *)
      return 0
      ;;
  esac
}

# @description Checks if a string contains only alpha-numeric characters.
# @arg $1 string The string to check.
# @exitcode 0 If the string is alpha-numeric.
# @exitcode 1 If the string is not alpha-numeric.
# @exitcode 126 If the string is empty.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.string.query.is_alpha_numeric() {
  [[ "${#@}" == "1" ]] || return 127
  case "${1}" in
    "")
      return 126
      ;;
    *[![:alnum:]]*)
      return 1
      ;;
    *)
      return 0
      ;;
  esac
}

# @description Checks if a string is a boolean (0 or 1).
# @arg $1 string The string to check.
# @exitcode 0 If the string is a boolean.
# @exitcode 1 If the string is not a boolean.
# @exitcode 126 If the string is empty.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.string.query.is_boolean() {
  [[ "${#@}" == "1" ]] || return 127
  case "${1}" in
    "")
      return 126
      ;;
    [0-1])
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

# @description Checks if a string contains a single character.
# @arg $1 string The string to check.
# @exitcode 0 If the string is a single character.
# @exitcode 1 If the string is not a single character.
# @exitcode 126 If the string is empty.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.string.query.is_char() {
  [[ "${#@}" == "1" ]] || return 127
  [[ -n "${1}" ]] || return 126
  [[ "${#1}" == "1" ]] || return 1
}

# @description Checks if a string contains only digits.
# @arg $1 string The string to check.
# @exitcode 0 If the string contains only digits.
# @exitcode 1 If the string does not contain only digits.
# @exitcode 126 If the string is empty.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.string.query.is_digit() {
  [[ "${#@}" == "1" ]] || return 127
  case "${1}" in
    "")
      return 126
      ;;
    *[!0-9]*)
      return 1
      ;;
    *)
      return 0
      ;;
  esac
}

# @description Checks if a string matches a regex.
# @arg $1 string The regex to use.
# @arg $2 string The string to check.
# @exitcode 0 If the string matches the regex.
# @exitcode 1 If the string does not match the regex.
# @exitcode 126 If an argument is empty.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.string.query.is_regex_match() {
  [[ "${#@}" == "2" ]] || return 127
  [[ -n "${1}" ]] || return 126
  [[ -n "${2}" ]] || return 126

  if [[ "${2}" =~ ${1} ]]; then
    return 0
  fi
  return 1
}

# @description Checks if a value is a non-empty string.
# @arg $1 string The value to check.
# @exitcode 0 If the value is a non-empty string.
# @exitcode 1 If the value is an empty string.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.string.query.is_string() {
  [[ "${#@}" == "1" ]] || return 127
  [[ -n "${1}" ]] || return 1
}
