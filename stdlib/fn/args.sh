#!/bin/bash

# stdlib fn args library

set -eo pipefail

SAFETY_LOADED="${SAFETY_LOADED:-1}"

_ARGS_ALLOW_NULL_BOOLEAN=0
_SAFE_FUNCTION_REGISTRY=()

stdlib.fn.args.require() {
  # $1 the number of arguments expected to be received
  # $@ the list of argument values to check
  #
  # _ARGS_ALLOW_NULL_BOOLEAN: accept empty args, and just check arg counts

  local args_allow_null_boolean="${_ARGS_ALLOW_NULL_BOOLEAN:-0}"

  local args_required_count="${1}"
  local args_optional_count="${2}"

  local arg_index=1
  local error_message="${FUNCNAME[1]}: Expected '${args_required_count}' required argument(s) and '${args_optional_count}' optional argument(s)."

  stdlib.string.assert.is_digit "${args_required_count}" || return 126
  stdlib.string.assert.is_digit "${args_optional_count}" || return 126
  stdlib.string.assert.is_boolean "${args_allow_null_boolean}" || return 126

  shift
  shift

  if (("${#@}" < "${args_required_count}" || "${#@}" > "${args_required_count}" + "${args_optional_count}")); then
    stdlib.logger.error "${error_message}"
    stdlib.logger.error "${FUNCNAME[1]}: Received '${#@}' argument(s)!"
    return 127
  fi

  if [[ "${args_allow_null_boolean}" == "0" ]]; then
    while (("${#@}" > "0")); do
      if [[ -z "${1}" ]]; then
        stdlib.logger.error "${error_message}"
        stdlib.logger.error "${FUNCNAME[1]}: Argument '${arg_index}' was null!"
        return 126
      fi
      shift
      ((arg_index++))
    done
  fi
}
