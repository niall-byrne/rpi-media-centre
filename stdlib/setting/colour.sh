#!/bin/bash

# stdlib setting colour library

builtin set -eo pipefail

stdlib.setting.colour.enable() {
  # shellcheck source=stdlib/setting/state/colour_enabled.sh
  source "${STDLIB_DIRECTORY}/setting/state/colour_enabled.sh"
  stdlib.setting.theme.load
}

stdlib.setting.colour.disable() {
  # shellcheck source=stdlib/setting/state/colour_disabled.sh
  source "${STDLIB_DIRECTORY}/setting/state/colour_disabled.sh"
  stdlib.setting.theme.load
}
