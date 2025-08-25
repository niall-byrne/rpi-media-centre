#!/bin/bash

# stdlib setting theme library

builtin set -eo pipefail

stdlib.setting.theme.get_colour() {

  local theme_colour

  theme_colour="STDLIB_COLOUR_${1}"

  if [[ ! -v "${theme_colour}" ]]; then
    stdlib.logger.warning "$(stdlib.message.get COLOUR_NOT_DEFINED "${1}")"
  fi

  builtin echo "${theme_colour}"
}

stdlib.setting.theme.load() {
  # shellcheck source=stdlib/setting/state/colour_theme.sh
  source "${STDLIB_DIRECTORY}/setting/state/colour_theme.sh"
}
