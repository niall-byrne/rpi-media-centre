#!/bin/bash
# @file debug.sh
# @brief A component for debugging parametrized tests.
# @description
#   This script is a component of the parametrization framework. It is not meant to be sourced directly.
#   It provides a function to output debug messages.

# stdlib testing parametrize debug component

set -eo pipefail

# @description Outputs a debug message.
# This is an internal function.
# @arg $1 string The debug text to output.
# @stdout The command to echo the debug message.
@parametrize._components.debug.message() {
  echo "echo '${1}'"
}
