#!/bin/bash
# @file clone.sh
# @brief A library for cloning functions.
# @description
#   This library provides a function to clone an existing function, giving it a new name.

# stdlib fn derive clone library

set -eo pipefail

# @description Clones a function, creating a new reference to it.
# @arg $1 string The name of the function to clone.
# @arg $2 string The new name for the function.
# @exitcode 126 If the source function does not exist, or if the new function name is empty.
# @exitcode 127 If the number of arguments is not 2.
stdlib.fn.derive.clone() {
  local function_name="${1}"
  local function_reference="${2}"

  [[ "${#@}" == 2 ]] || return 127
  stdlib.fn.assert.is_fn "${function_name}" || return 126
  [[ -n "${function_reference}" ]] || return 126

  #:nocov:
  # bashcov doesn't report this section correctly
  eval "$(
    echo "${function_reference}()"
    declare -f "${function_name}" | tail -n +2
  )"
  #:nocov:
}
