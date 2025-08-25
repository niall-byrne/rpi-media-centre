#!/bin/bash

# stdlib logger library

builtin set -eo pipefail

_STDLIB_LOGGING_MESSAGE_PREFIX=""
_STDLIB_LOGGING_DECORATORS=("__testing.protected")

stdlib.logger.traceback() {
  local fn_name_index
  local fn_name_indent=">"

  stdlib.message.get TRACEBACK_HEADER
  builtin echo

  for ((fn_name_index = ("${#FUNCNAME[@]}" - 1); fn_name_index > 1; fn_name_index--)); do
    builtin echo "${fn_name_indent}  ${BASH_SOURCE["${fn_name_index}"]}:${BASH_LINENO[$(("${fn_name_index}" - 1))]}:${FUNCNAME["${fn_name_index}"]}()"
    fn_name_indent+=">"
  done
}

stdlib.logger.error() {
  # $1: the input string to log
  #
  # _STDLIB_LOGGING_MESSAGE_PREFIX: a prefix for the message (defaults to the calling function's name)

  {
    stdlib.logger.__message_prefix
    stdlib.string.colour "${STDLIB_THEME_LOGGER_ERROR}" "${1}"
  } >&2 # KCOV_EXCLUDE_LINE
}

stdlib.logger.warning() {
  # $1: the input string to log
  #
  # _STDLIB_LOGGING_MESSAGE_PREFIX: a prefix for the message (defaults to the calling function's name)

  {
    stdlib.logger.__message_prefix
    stdlib.string.colour "${STDLIB_THEME_LOGGER_WARNING}" "${1}"
  } >&2 # KCOV_EXCLUDE_LINE
}

stdlib.logger.info() {
  # $1: the input string to log
  #
  # _STDLIB_LOGGING_MESSAGE_PREFIX: a prefix for the message (defaults to the calling function's name)

  stdlib.logger.__message_prefix
  stdlib.string.colour "${STDLIB_THEME_LOGGER_INFO}" "${1}"
}

stdlib.logger.notice() {
  # $1: the input string to log
  #
  # _STDLIB_LOGGING_MESSAGE_PREFIX: a prefix for the message (defaults to the calling function's name)

  stdlib.logger.__message_prefix
  stdlib.string.colour "${STDLIB_THEME_LOGGER_NOTICE}" "${1}"
}

stdlib.logger.success() {
  # $1: the input string to log
  #
  # _STDLIB_LOGGING_MESSAGE_PREFIX: a prefix for the message (defaults to the calling function's name)

  stdlib.logger.__message_prefix
  stdlib.string.colour "${STDLIB_THEME_LOGGER_SUCCESS}" "${1}"
}

stdlib.logger.__message_prefix() {
  local message_prefix="${_STDLIB_LOGGING_MESSAGE_PREFIX:-${FUNCNAME[3]}}"
  if stdlib.array.query.is_contains "${message_prefix}" _STDLIB_LOGGING_DECORATORS; then
    message_prefix="${FUNCNAME[4]}"
  fi

  builtin echo -n "${message_prefix}: "
}
