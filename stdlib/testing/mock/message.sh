#!/bin/bash

# stdlib testing mock messages library

builtin set -eo pipefail

_testing.mock.message.get() {
  # $1: the message key to retrieve
  # $2: interpolation option 1
  # $3: interpolation option 2

  local key="${1}"
  local message
  local option1="${2}"
  local option2="${3}"
  local required_options=0
  local return_status=0

  case "${key}" in
    MOCK_CALL_ACTUAL_PREFIX)
      required_options=0
      message="Actual call"
      ;;
    MOCK_CALL_N_NOT_AS_EXPECTED)
      required_options=2
      message="Mock '${option1}' call ${option2} was not as expected!"
      ;;
    MOCK_CALLED_N_TIMES)
      required_options=2
      message="Mock '${option1}' was called ${option2} times!"
      ;;
    MOCK_NOT_CALLED)
      required_options=1
      message="Mock '${option1}' was not called!"
      ;;
    MOCK_NOT_CALLED_ONCE_WITH)
      required_options=2
      message="Mock '${option1}' was not called once with '${option2}' !"
      ;;
    MOCK_NOT_CALLED_WITH)
      required_options=2
      message="Mock '${option1}' was not called with '${option2}' !"
      ;;
    "")
      required_options=0
      return_status=126
      message="$(__testing.protected stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      required_options=0
      return_status=126
      message="Unknown message key '${key}'"
      ;;
  esac

  (("${#@}" - 1 == required_options)) || {
    message="$(__testing.protected stdlib.message.get ARGUMENTS_INVALID)"
    return_status=127
  }

  ((return_status == 0)) || {
    __testing.protected stdlib.logger.error "${message}"
    return ${return_status}
  }

  builtin echo -n "${message}"
}
