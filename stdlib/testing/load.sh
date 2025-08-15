#!/bin/bash

# stdlib testing source library

set -eo pipefail

_testing.load() {
  # $1: the module to source with error support

  [[ "${#@}" == 1 ]] || {
    _testing.error "_testing.load: Invalid arguments!"
    return 127
  }

  echo -e "    ${STDLIB_COLOUR_GREY}Loading module ${1} ...${STDLIB_COLOUR_NC}"

  # shellcheck source=/dev/null
  . "${1}" 2> /dev/null || {
    _testing.error "The module '${1}' could not be found!"
    return 126
  }
}
