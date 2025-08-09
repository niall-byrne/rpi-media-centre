#!/bin/bash

# pictl cli pretty pad library

set -eo pipefail

_cli_pretty_pad_left() {
  # $1: the width to pad with
  # $2: the string to pad

  printf "%*s%s"$'\n' "${1}" " " "${2}"
}

stdlib.fn.derive.pipeable "_cli_pretty_pad_left" "2"

stdlib.fn.derive.var "_cli_pretty_pad_left"

_cli_pretty_pad_right() {
  # $1: the width to pad with
  # $2: the string to pad

  printf "%s%*s"$'\n' "${2}" "${1}" " "
}

stdlib.fn.derive.pipeable "_cli_pretty_pad_right" "2"

stdlib.fn.derive.var "_cli_pretty_pad_right"
