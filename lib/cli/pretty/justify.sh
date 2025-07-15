#!/bin/bash

# pictl cli pretty justify library

set -eo pipefail

_cli_pretty_justify_left() {
  # $1: the column width to justify with
  # $2: the string to justify

  printf "%-${1}b"$'\n' "${2}"
}

_io_make_pipeable "_cli_pretty_justify_left" "2"

_io_make_var_function "_cli_pretty_justify_left"

_cli_pretty_justify_right() {
  # $1: the column width to justify with
  # $2: the variable name to justify

  printf "%${1}s"$'\n' "${2}"
}

_io_make_pipeable "_cli_pretty_justify_right" "2"

_io_make_var_function "_cli_pretty_justify_right"
