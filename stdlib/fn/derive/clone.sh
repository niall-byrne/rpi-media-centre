#!/bin/bash

# stdlib fn derive clone library

builtin set -eo pipefail

stdlib.fn.derive.clone() {
  # $1: the original function name
  # $2: the function's new reference name

  local function_name="${1}"
  local function_reference="${2}"

  [[ "${#@}" == 2 ]] || return 127
  stdlib.fn.assert.is_fn "${function_name}" || return 126
  [[ -n "${function_reference}" ]] || return 126
  stdlib.fn.assert.is_valid_name "${function_reference}" || return 126

  builtin eval "$(
    builtin echo "${function_reference}()"
    builtin declare -f "${function_name}" | "${_STDLIB_BINARY_TAIL}" -n +2
  )"
}
