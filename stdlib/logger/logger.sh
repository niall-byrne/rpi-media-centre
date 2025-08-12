#!/bin/bash

# stdlib logger library

set -eo pipefail

stdlib.logger.traceback() {
  local fn_name_index
  local fn_name_indent=">"

  echo "Callstack:"

  for ((fn_name_index = ("${#FUNCNAME[@]}" - 1); fn_name_index > 1; fn_name_index--)); do
    echo "${fn_name_indent}  ${BASH_SOURCE["${fn_name_index}"]}:${BASH_LINENO[$(("${fn_name_index}" - 1))]}:${FUNCNAME["${fn_name_index}"]}()"
    fn_name_indent+=">"
  done
}

stdlib.logger.error() {
  # $1: the input string to log

  {
    echo -n "${FUNCNAME[2]}: "
    stdlib.string.colour "LIGHT_RED" "${1}"
    #:nocov:
  } >&2
  #:nocov:
}

stdlib.logger.warning() {
  # $1: the input string to log

  {
    echo -n "${FUNCNAME[2]}: "
    stdlib.string.colour "YELLOW" "${1}"
    #:nocov:
  } >&2
  #:nocov:
}

stdlib.logger.info() {
  # $1: the input string to log

  echo -n "${FUNCNAME[2]}: "
  stdlib.string.colour "WHITE" "${1}"
}

stdlib.logger.notice() {
  # $1: the input string to log

  echo -n "${FUNCNAME[2]}: "
  stdlib.string.colour "GREY" "${1}"
}

stdlib.logger.success() {
  # $1: the input string to log

  echo -n "${FUNCNAME[2]}: "
  stdlib.string.colour "GREEN" "${1}"
}
