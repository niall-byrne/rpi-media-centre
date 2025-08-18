#!/bin/bash

# pictl cli logger library

set -eo pipefail

_cli_log_error() {
  # $1: the input string to colourize

  {
    _cli_pretty_colour "LOGGER_ERROR" "${1}"
  } >&2 # KCOV_EXCLUDE_LINE
}

_cli_log_info() {
  # $1: the input string to colourize

  _cli_pretty_colour "LOGGER_INFO" "${1}"
}

_cli_log_notice() {
  # $1: the input string to colourize

  _cli_pretty_colour "LOGGER_NOTICE" "${1}"
}

_cli_log_success() {
  # $1: the input string to colourize

  _cli_pretty_colour "LOGGER_SUCCESS" "${1}"
}

_cli_log_warning() {
  # $1: the input string to colourize

  {
    _cli_pretty_colour "LOGGER_WARNING" "${1}"
  } >&2 # KCOV_EXCLUDE_LINE
}
