#!/bin/bash

# stdlib setting library

builtin set -eo pipefail

# shellcheck source=stdlib/setting/colour.sh
source "${STDLIB_DIRECTORY}/setting/colour.sh"
# shellcheck source=stdlib/setting/theme.sh
source "${STDLIB_DIRECTORY}/setting/theme.sh"

# Defaults (enable with silent fallback)
_STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="1" stdlib.setting.colour.enable
