#!/bin/bash

# stdlib testing parametrize debug component

builtin set -eo pipefail

@parametrize._components.debug.message() {
  # $1: the debug text to output

  builtin echo "builtin echo '${1}'"
}
