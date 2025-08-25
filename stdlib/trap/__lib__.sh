#!/bin/bash

# stdlib trap library

builtin set -eo pipefail

# shellcheck source=stdlib/trap/create.sh
source "${STDLIB_DIRECTORY}/trap/create.sh"
# shellcheck source=stdlib/trap/trap.sh
source "${STDLIB_DIRECTORY}/trap/trap.sh"
