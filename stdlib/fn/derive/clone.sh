#!/bin/bash

# stdlib fn derive clone library

set -eo pipefail

stdlib.fn.derive.clone() {
  # $1: the original function name
  # $2: the function's new reference name

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
