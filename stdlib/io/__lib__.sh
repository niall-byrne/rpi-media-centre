#!/bin/bash

# stdlib io library

builtin set -eo pipefail

# shellcheck source=stdlib/io/path/__lib__.sh
source "${STDLIB_DIRECTORY}/io/path/__lib__.sh"
# shellcheck source=stdlib/io/stdin.sh
source "${STDLIB_DIRECTORY}/io/stdin.sh"
