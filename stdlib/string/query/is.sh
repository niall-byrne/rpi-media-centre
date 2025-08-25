#!/bin/bash

# stdlib string query is library

builtin set -eo pipefail

stdlib.string.query.is_alpha() {
  # $1: the string to check

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

stdlib.string.query.is_alpha_numeric() {
  # $1: the string to check

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

stdlib.string.query.is_boolean() {
  # $1: the string to check

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

stdlib.string.query.is_char() {
  # $1: the string to check

  [[ "${#@}" == "1" ]] || return 127
  [[ -n "${1}" ]] || return 126
  [[ "${#1}" == "1" ]] || return 1
}

stdlib.string.query.is_digit() {
  # $1: the string to check

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

stdlib.string.query.is_integer() {
  # $1: the string to check

  [[ "${#@}" == "1" ]] || return 127
  [[ -n "${1}" ]] || return 126

  if { test "${1}" -gt "-1" 2> /dev/null || test "${1}" -lt "1" 2> /dev/null; }; then
    return 0
  fi

  return 1
}

stdlib.string.query.is_integer_with_range() {
  # $1: the range start point
  # $2: the range end point
  # $3: the string to check

  [[ "${#@}" == "3" ]] || return 127
  stdlib.string.query.is_integer "${1}" || return 126
  stdlib.string.query.is_integer "${2}" || return 126
  [[ "${1}" -le ${2} ]] || return 126
  stdlib.string.query.is_integer "${3}" || return 126

  if [[ "${3}" -ge "${1}" ]] &&
    [[ "${3}" -le "${2}" ]]; then
    return 0
  fi

  return 1
}

stdlib.string.query.is_octal_permission() {
  # $2: the string to check

  [[ "${#@}" == "1" ]] || return 127
  case "${1}" in
    "")
      return 126
      ;;
    [0-7][0-7][0-7] | [0-7][0-7][0-7][0-7])
      return 0
      ;;
    *)
      return 1
      ;;
  esac

}

stdlib.string.query.is_regex_match() {
  # $1: the regex to use
  # $2: the string to check

  [[ "${#@}" == "2" ]] || return 127
  [[ -n "${1}" ]] || return 126
  [[ -n "${2}" ]] || return 126

  if [[ "${2}" =~ ${1} ]]; then
    return 0
  fi
  return 1
}

stdlib.string.query.is_string() {
  # $1: the string to check

  [[ "${#@}" == "1" ]] || return 127
  [[ -n "${1}" ]] || return 1
}
