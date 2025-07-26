#!/bin/bash

# pictl testing module library

set -eo pipefail

load() {
  # $1: the module to source with error support

  echo -e "    ${RPI_COLOUR_GRAY}Loading module ${1} ...${RPI_COLOUR_NC}"

  # shellcheck source=/dev/null
  . "${1}" ||
    _test_error "The module '${1}' could not be found!"
}
