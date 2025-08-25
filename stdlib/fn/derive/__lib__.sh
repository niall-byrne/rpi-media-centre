#!/bin/bash

# stdlib fn derive library

builtin set -eo pipefail

# shellcheck source=stdlib/fn/derive/clone.sh
source "${STDLIB_DIRECTORY}/fn/derive/clone.sh"
# shellcheck source=stdlib/fn/derive/pipeable.sh
source "${STDLIB_DIRECTORY}/fn/derive/pipeable.sh"
# shellcheck source=stdlib/fn/derive/var.sh
source "${STDLIB_DIRECTORY}/fn/derive/var.sh"
