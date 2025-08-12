#!/bin/bash

# stdlib fn args library

set -eo pipefail

SAFETY_LOADED="${SAFETY_LOADED:-1}"
_ARGS_NULL_SAFE=()

stdlib.fn.args.require() {
  # $1 the number of arguments expected to be received
  # $@ the list of argument values to check
  #
  # _ARGS_NULL_SAFE: an array of arguments that are "null safe", they can be empty values

  # shellcheck disable=SC2034
  local args_null_safe_array=("${_ARGS_NULL_SAFE[@]}")

  local arg_index=1
  local args_optional_count="${2}"
  local args_required_count="${1}"
  local args_error_message="${FUNCNAME[1]}: Expected '${args_required_count}' required argument(s) and '${args_optional_count}' optional argument(s)."

  stdlib.string.assert.is_digit "${args_required_count}" || return 126
  stdlib.string.assert.is_digit "${args_optional_count}" || return 126
  stdlib.array.assert.is_array args_null_safe_array || return 126

  shift
  shift

  if (("${#@}" < "${args_required_count}" || "${#@}" > "${args_required_count}" + "${args_optional_count}")); then
    stdlib.logger.error "${args_error_message}"
    stdlib.logger.error "${FUNCNAME[1]}: Received '${#@}' argument(s)!"
    return 127
  fi

  while (("${#@}" > "0")); do
    if [[ -z "${1}" ]]; then
      if ! stdlib.array.query.contains args_null_safe_array "${arg_index}"; then
        stdlib.logger.error "${args_error_message}"
        stdlib.logger.error "${FUNCNAME[1]}: Argument '${arg_index}' was null and is not null safe!"
        return 126
      fi
    fi
    shift
    ((arg_index++))
  done
}
