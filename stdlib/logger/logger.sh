#!/bin/bash
# @file logger.sh
# @brief A library for logging messages.
# @description
#   This library provides functions for logging messages of different levels (error, warning, info, etc.).
#   It also provides a function to print a traceback.

# stdlib logger library

set -eo pipefail

# @description Prints the callstack of the shell script.
# @stdout The callstack, with each function call indented.
stdlib.logger.traceback() {
  local fn_name_index
  local fn_name_indent=">"

  echo "Callstack:"

  for ((fn_name_index = ("${#FUNCNAME[@]}" - 1); fn_name_index > 1; fn_name_index--)); do
    echo "${fn_name_indent}  ${FUNCNAME[fn_name_index]}"
    fn_name_indent+=">"
  done
}

# @description Logs an error message to stderr.
# It also prints a traceback.
# @arg $1 string The error message to log.
# @stderr The traceback and the formatted error message.
stdlib.logger.error() {
  {
    stdlib.logger.traceback
    echo -n "${FUNCNAME[2]}: "
    stdlib.string.colour "LIGHT_RED" "${1}"
    #:nocov:
  } >&2
  #:nocov:
}

# @description Logs a warning message to stderr.
# @arg $1 string The warning message to log.
# @stderr The formatted warning message.
stdlib.logger.warning() {
  {
    echo -n "${FUNCNAME[2]}: "
    stdlib.string.colour "YELLOW" "${1}"
    #:nocov:
  } >&2
  #:nocov:
}

# @description Logs an info message to stdout.
# @arg $1 string The info message to log.
# @stdout The formatted info message.
stdlib.logger.info() {
  echo -n "${FUNCNAME[2]}: "
  stdlib.string.colour "WHITE" "${1}"
}

# @description Logs a notice message to stdout.
# @arg $1 string The notice message to log.
# @stdout The formatted notice message.
stdlib.logger.notice() {
  echo -n "${FUNCNAME[2]}: "
  stdlib.string.colour "GREY" "${1}"
}

# @description Logs a success message to stdout.
# @arg $1 string The success message to log.
# @stdout The formatted success message.
stdlib.logger.success() {
  echo -n "${FUNCNAME[2]}: "
  stdlib.string.colour "GREEN" "${1}"
}
