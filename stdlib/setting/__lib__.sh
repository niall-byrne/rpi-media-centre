#!/bin/bash

# stdlib setting library

builtin set -eo pipefail

# shellcheck source=stdlib/setting/colour.sh
source "${STDLIB_DIRECTORY}/setting/colour.sh"
# shellcheck source=stdlib/setting/theme.sh
source "${STDLIB_DIRECTORY}/setting/theme.sh"

# Defaults
stdlib.setting.colour.enable
