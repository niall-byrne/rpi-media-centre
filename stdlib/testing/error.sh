#!/bin/bash
# @file error.sh
# @brief A library for handling testing errors.
# @description
#   This library provides a function to display error messages for testing purposes.

# stdlib testing error library

set -eo pipefail

# @description Displays an error message to stderr.
# @arg $@ The error messages to display.
# @exitcode 127 Always.
# @stderr The formatted error message.
_testing.error() {
  {
    (
      while [[ -n "${1}" ]]; do
        echo "${STDLIB_COLOUR_LIGHT_RED}${1}${STDLIB_COLOUR_NC}"
        shift
      done
    )
    #:nocov:
    # bashcov doesn't report this section correctly
  } >&2
  #:nocov:
  return 127
}
