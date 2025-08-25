#!/bin/bash

# stdlib io path library

builtin set -eo pipefail

# shellcheck source=stdlib/io/path/assert/__lib__.sh
source "${STDLIB_DIRECTORY}/io/path/assert/__lib__.sh"
# shellcheck source=stdlib/io/path/query/__lib__.sh
source "${STDLIB_DIRECTORY}/io/path/query/__lib__.sh"
