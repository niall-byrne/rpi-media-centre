#!/bin/bash
# @file load.sh
# @brief A library for loading testing modules.
# @description
#   This library provides a function to load testing modules with error support.

# stdlib testing source library

set -eo pipefail

# @description Loads a testing module.
# @arg $1 string The path to the module to load.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @exitcode ? Propagated from _testing.error if the module is not found.
# @stdout A message indicating that the module is being loaded.
_testing.load() {
  [[ "${#@}" == 1 ]] || {
    _testing.error "_testing.load: Invalid arguments!"
    return 127
  }

  echo -e "    ${STDLIB_COLOUR_GREY}Loading module ${1} ...${STDLIB_COLOUR_NC}"

  # shellcheck source=/dev/null
  . "${1}" 2> /dev/null || _testing.error "The module '${1}' could not be found!"
}
