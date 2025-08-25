#!/bin/bash

# stdlib string assert is library

builtin set -eo pipefail

stdlib.string.assert.is_alpha() {
  # $1: the string to check

  local return_code=0

  stdlib.string.query.is_alpha "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get IS_NOT_ALPHABETIC "${1}")"
      ;;
  esac

  return "${return_code}"
}

stdlib.string.assert.is_alpha_numeric() {
  # $1: the string to check

  local return_code=0

  stdlib.string.query.is_alpha_numeric "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get IS_NOT_ALPHA_NUMERIC "${1}")"
      ;;
  esac

  return "${return_code}"
}

stdlib.string.assert.is_boolean() {
  # $1: the string to check

  local return_code=0

  stdlib.string.query.is_boolean "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get IS_NOT_BOOLEAN "${1}")"
      ;;
  esac

  return "${return_code}"
}

stdlib.string.assert.is_char() {
  # $1: the string to check

  local return_code=0

  stdlib.string.query.is_char "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get IS_NOT_CHAR "${1}")"
      ;;
  esac

  return "${return_code}"
}

stdlib.string.assert.is_digit() {
  # $1: the string to check

  local return_code=0

  stdlib.string.query.is_digit "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get IS_NOT_DIGIT "${1}")"
      ;;
  esac

  return "${return_code}"
}

stdlib.string.assert.is_integer() {
  # $1: the string to check

  local return_code=0

  stdlib.string.query.is_integer "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get IS_NOT_INTEGER "${1}")"
      ;;
  esac

  return "${return_code}"
}

stdlib.string.assert.is_integer_with_range() {
  # $1: the range start point
  # $2: the range end point
  # $3: the digit itself

  local return_code=0

  stdlib.string.query.is_integer_with_range "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    126 | 127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get IS_NOT_INTEGER_IN_RANGE "${1}" "${2}" "${3}")"
      ;;
  esac

  return "${return_code}"
}

stdlib.string.assert.is_octal_permission() {
  # $1: the string to check

  local return_code=0

  stdlib.string.query.is_octal_permission "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get IS_NOT_OCTAL_PERMISSION "${1}")"
      ;;
  esac

  return "${return_code}"
}

stdlib.string.assert.is_regex_match() {
  # $1: the regex to match
  # $2: the string to check

  local return_code=0

  stdlib.string.query.is_regex_match "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get REGEX_DOES_NOT_MATCH "${1}" "${2}")"
      ;;
  esac

  return "${return_code}"
}

stdlib.string.assert.is_string() {
  # $1: the string to check

  local return_code=0

  stdlib.string.query.is_string "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get IS_NOT_SET_STRING "${1}")"
      ;;
  esac

  return "${return_code}"
}
