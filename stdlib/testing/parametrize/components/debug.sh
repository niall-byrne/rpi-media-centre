#!/bin/bash

# stdlib testing parametrize debug component

set -eo pipefail

@parametrize._components.debug.message() {
  # $1: the debug text to output

  echo "echo '${1}'"
}
