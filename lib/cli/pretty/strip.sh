#!/bin/bash

# pictl cli pretty string library

set -eo pipefail

_cli_pretty_strip_trailing_newline() {
  # $1: the input string to modify

  echo -n "${1}"
}

stdlib.fn.derive.pipeable "_cli_pretty_strip_trailing_newline" "1"
