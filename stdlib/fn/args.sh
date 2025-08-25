#!/bin/bash

# stdlib fn args library

builtin set -eo pipefail

_STDLIB_ARGS_CALLER_FN_NAME=""
_STDLIB_ARGS_NULL_SAFE=()

stdlib.fn.args.require() {
  # $1 the number of arguments expected to be received
  # $@ the list of argument values to check
  #
  # _STDLIB_ARGS_CALLER_FN_NAME:    set to override the name of the calling function in logging messages
  # _STDLIB_ARGS_NULL_SAFE: an array of argument indexes that are "null safe" (they can be empty values)

  # shellcheck disable=SC2034
  local args_null_safe_array=("${_STDLIB_ARGS_NULL_SAFE[@]}")
  local _STDLIB_LOGGING_MESSAGE_PREFIX="${_STDLIB_ARGS_CALLER_FN_NAME:-"${FUNCNAME[1]}"}"

  local arg_index=1
  local args_optional_count="${2}"
  local args_required_count="${1}"

  stdlib.string.assert.is_digit "${args_required_count}" || return 126
  stdlib.string.assert.is_digit "${args_optional_count}" || return 126
  stdlib.array.assert.is_array args_null_safe_array || return 126

  shift
  shift

  if (("${#@}" < "${args_required_count}" || "${#@}" > "${args_required_count}" + "${args_optional_count}")); then
    stdlib.logger.error "$(stdlib.message.get ARGUMENT_REQUIREMENTS_VIOLATION "${args_required_count}" "${args_optional_count}")"
    stdlib.logger.error "$(stdlib.message.get ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL "${#@}")"
    return 127
  fi

  for ((arg_index = 1; arg_index <= "${#@}"; arg_index++)); do
    if [[ -z "${!arg_index}" ]]; then
      if ! stdlib.array.query.is_contains "${arg_index}" args_null_safe_array; then
        stdlib.logger.error "$(stdlib.message.get ARGUMENT_REQUIREMENTS_VIOLATION "${args_required_count}" "${args_optional_count}")"
        stdlib.logger.error "$(stdlib.message.get ARGUMENT_REQUIREMENTS_VIOLATION_NULL "${arg_index}")"
        return 126
      fi
    fi
  done
}
