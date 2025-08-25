#!/bin/bash

# stdlib fn library

builtin set -eo pipefail

# shellcheck source=stdlib/fn/args.sh
source "${STDLIB_DIRECTORY}/fn/args.sh"
# shellcheck source=stdlib/fn/assert/__lib__.sh
source "${STDLIB_DIRECTORY}/fn/assert/__lib__.sh"
# shellcheck source=stdlib/fn/derive/__lib__.sh
source "${STDLIB_DIRECTORY}/fn/derive/__lib__.sh"
# shellcheck source=stdlib/fn/query/__lib__.sh
source "${STDLIB_DIRECTORY}/fn/query/__lib__.sh"
