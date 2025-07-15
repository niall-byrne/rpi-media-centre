#!/bin/bash

# pictl cli pretty string library

set -eo pipefail

_cli_pretty_string_first_char_is() {
  # $1 the value to check for
  # $2 the string to check

  [[ "${#1}" -gt 1 ]] && return 1
  [[ "${2:0:1}" == "${1}" ]]
}

_io_make_pipeable "_cli_pretty_string_first_char_is" "2"

_cli_pretty_string_starts_with() {
  # $2 the value to check for
  # $1 the string to check

  [[ "${2}" == "${1}"* ]]
}

_io_make_pipeable "_cli_pretty_string_starts_with" "2"
