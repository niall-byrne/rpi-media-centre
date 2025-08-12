#!/bin/bash

# stdlib string assert is library

set -eo pipefail

stdlib.string.assert.is_alpha() {
  # $1: the string name

  local return_code=0

  stdlib.string.query.is_alpha "${@}" || return_code="$?"

  case "${return_code}" in
    #:nocov:
    # bashcov doesn't report this section correctly
    0) ;;
    #:nocov:
    127)
      stdlib.logger.error "Invalid arguments provided!"
      ;;
    *)
      stdlib.logger.error "The value '${1}' is not a set alphabetic only string!"
      ;;
  esac

  return "${return_code}"
}

stdlib.string.assert.is_alpha_numeric() {
  # $1: the string name

  local return_code=0

  stdlib.string.query.is_alpha_numeric "${@}" || return_code="$?"

  case "${return_code}" in
    #:nocov:
    # bashcov doesn't report this section correctly
    0) ;;
    #:nocov:
    127)
      stdlib.logger.error "Invalid arguments provided!"
      ;;
    *)
      stdlib.logger.error "The value '${1}' is not a set alpha-numeric only string!"
      ;;
  esac

  return "${return_code}"
}

stdlib.string.assert.is_boolean() {
  # $1: the string name

  local return_code=0

  stdlib.string.query.is_boolean "${@}" || return_code="$?"

  case "${return_code}" in
    #:nocov:
    # bashcov doesn't report this section correctly
    0) ;;
    #:nocov:
    127)
      stdlib.logger.error "Invalid arguments provided!"
      ;;
    *)
      stdlib.logger.error "The value '${1}' is not a set string containing a boolean (0 or 1)!"
      ;;
  esac

  return "${return_code}"
}

stdlib.string.assert.is_char() {
  # $1: the string name

  local return_code=0

  stdlib.string.query.is_char "${@}" || return_code="$?"

  case "${return_code}" in
    #:nocov:
    # bashcov doesn't report this section correctly
    0) ;;
    #:nocov:
    127)
      stdlib.logger.error "Invalid arguments provided!"
      ;;
    *)
      stdlib.logger.error "The value '${1}' is not a set string containing a single char!"
      ;;
  esac

  return "${return_code}"
}

stdlib.string.assert.is_digit() {
  # $1: the string name

  local return_code=0

  stdlib.string.query.is_digit "${@}" || return_code="$?"

  case "${return_code}" in
    #:nocov:
    # bashcov doesn't report this section correctly
    0) ;;
    #:nocov:
    127)
      stdlib.logger.error "Invalid arguments provided!"
      ;;
    *)
      stdlib.logger.error "The value '${1}' is not a set string containing a digit!"
      ;;
  esac

  return "${return_code}"
}

stdlib.string.assert.is_integer() {
  # $1: the string name

  local return_code=0

  stdlib.string.query.is_integer "${@}" || return_code="$?"

  case "${return_code}" in
    #:nocov:
    # bashcov doesn't report this section correctly
    0) ;;
    #:nocov:
    127)
      stdlib.logger.error "Invalid arguments provided!"
      ;;
    *)
      stdlib.logger.error "The value '${1}' is not a set string containing an integer!"
      ;;
  esac

  return "${return_code}"
}

stdlib.string.assert.is_regex_match() {
  # $1: the regex to match
  # $2: the string name

  local return_code=0

  stdlib.string.query.is_regex_match "${@}" || return_code="$?"

  case "${return_code}" in
    #:nocov:
    # bashcov doesn't report this section correctly
    0) ;;
    #:nocov:
    127)
      stdlib.logger.error "Invalid arguments provided!"
      ;;
    *)
      stdlib.logger.error "The regex '${1}' does not match the value '${2}'!"
      ;;
  esac

  return "${return_code}"
}

stdlib.string.assert.is_string() {
  # $1: the string name

  local return_code=0

  stdlib.string.query.is_string "${@}" || return_code="$?"

  case "${return_code}" in
    #:nocov:
    # bashcov doesn't report this section correctly
    0) ;;
    #:nocov:
    127)
      stdlib.logger.error "Invalid arguments provided!"
      ;;
    *)
      stdlib.logger.error "The value '${1}' is not a set string!"
      ;;
  esac

  return "${return_code}"
}
