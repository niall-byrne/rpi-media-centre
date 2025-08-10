#!/bin/bash
# @file args.sh
# @brief A library for argument validation.
# @description
#   This library provides a function to require a certain number of arguments for a function.

# stdlib fn args library

set -eo pipefail

SAFETY_LOADED="${SAFETY_LOADED:-1}"

_ARGS_ALLOW_NULL_BOOLEAN=0
_SAFE_FUNCTION_REGISTRY=()

# @description Checks if a function received the expected number of arguments.
# It can also check if the arguments are null or empty.
# This function is meant to be called from within another function.
# @env _ARGS_ALLOW_NULL_BOOLEAN If set to 1, empty arguments are allowed. Defaults to 0.
# @arg $1 integer The number of required arguments.
# @arg $2 integer The number of optional arguments.
# @arg $@ The arguments to check. These should be the arguments of the calling function.
# @exitcode 126 If the provided counts are not digits, or if an argument is null when not allowed.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @stderr Logs an error message if the validation fails.
stdlib.fn.args.require() {
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
