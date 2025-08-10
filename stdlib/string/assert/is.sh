#!/bin/bash
# @file is.sh
# @brief A library for making assertions about strings.
# @description
#   This library provides functions to make assertions about strings,
#   such as checking if a string is alpha, alpha-numeric, a boolean, etc.

# stdlib string assert is library

set -eo pipefail

# @description Asserts that a string contains only alphabetic characters.
# @arg $1 string The string to check.
# @exitcode 0 If the string is alphabetic.
# @exitcode 1 If the string is not alphabetic.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @stderr Logs an error message if the assertion fails.
stdlib.string.assert.is_alpha() {
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

# @description Asserts that a string contains only alpha-numeric characters.
# @arg $1 string The string to check.
# @exitcode 0 If the string is alpha-numeric.
# @exitcode 1 If the string is not alpha-numeric.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @stderr Logs an error message if the assertion fails.
stdlib.string.assert.is_alpha_numeric() {
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

# @description Asserts that a string is a boolean (0 or 1).
# @arg $1 string The string to check.
# @exitcode 0 If the string is a boolean.
# @exitcode 1 If the string is not a boolean.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @stderr Logs an error message if the assertion fails.
stdlib.string.assert.is_boolean() {
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

# @description Asserts that a string contains a single character.
# @arg $1 string The string to check.
# @exitcode 0 If the string is a single character.
# @exitcode 1 If the string is not a single character.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @stderr Logs an error message if the assertion fails.
stdlib.string.assert.is_char() {
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

# @description Asserts that a string contains only digits.
# @arg $1 string The string to check.
# @exitcode 0 If the string contains only digits.
# @exitcode 1 If the string does not contain only digits.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @stderr Logs an error message if the assertion fails.
stdlib.string.assert.is_digit() {
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

# @description Asserts that a string matches a regex.
# @arg $1 string The regex to match.
# @arg $2 string The string to check.
# @exitcode 0 If the string matches the regex.
# @exitcode 1 If the string does not match the regex.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @stderr Logs an error message if the assertion fails.
stdlib.string.assert.is_regex_match() {
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

# @description Asserts that a value is a non-empty string.
# @arg $1 string The value to check.
# @exitcode 0 If the value is a non-empty string.
# @exitcode 1 If the value is an empty string.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @stderr Logs an error message if the assertion fails.
stdlib.string.assert.is_string() {
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
