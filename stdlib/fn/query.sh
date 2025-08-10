#!/bin/bash
# @file query.sh
# @brief A library for querying information about functions.
# @description
#   This library provides functions to query information about functions,
#   such as checking if a function exists.

# stdlib fn query library

set -eo pipefail

# @description Checks if a function exists.
# @arg $1 string The name of the function to check.
# @exitcode 0 If the function exists.
# @exitcode 1 If the function does not exist.
# @exitcode 126 If wrong or invalid arguments have been passed.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.fn.query.is_fn() {
  [[ "${#@}" == "1" ]] || return 127
  [[ -n "${1}" ]] || return 126

  if ! declare -f "${1}" > /dev/null; then
    return 1
  fi
  return 0
}
