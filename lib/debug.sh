#!/bin/bash

# pictl debug library

set -eo pipefail

_debug_with() {
  # $@: the command to execute

  if _debug_is_enabled; then
    "$@"
  fi
}

_debug_error_handler() {
  local COMMAND="${BASH_COMMAND}"
  local EXIT_CODE="$?"
  local SCRIPT_FILE="${BASH_SOURCE[1]}"
  local LINE_NUMBER="${BASH_LINENO[0]}"

  {
    echo "**ERROR** source file: ${SCRIPT_FILE} -- line: ${LINE_NUMBER} -- command: ${COMMAND} -- exit code: ${EXIT_CODE}"
  } >&2

  exit "${EXIT_CODE}"
}

_debug_is_enabled() {
  [[ -n "${RPI_DEBUG}" ]]
}
