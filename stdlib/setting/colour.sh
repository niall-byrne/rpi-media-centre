#!/bin/bash

# stdlib setting colour library

builtin set -eo pipefail

_STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN=""

stdlib.setting.colour.enable() {
  # _STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN: disable error message on initialization failure

  local silent_fallback_boolean="${_STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN:-0}"
  local error_message=""

  if ! "${_STDLIB_BINARY_TPUT}" init 2> /dev/null; then
    if [[ "${silent_fallback_boolean}" != "1" ]]; then
      stdlib.setting.colour.enable._generate_error_message
      return 127
    fi
    stdlib.setting.colour.disable
    return 0
  fi

  # shellcheck source=stdlib/setting/state/colour_enabled.sh
  source "${STDLIB_DIRECTORY}/setting/state/colour_enabled.sh"
  stdlib.setting.theme.load
}

stdlib.setting.colour.enable._generate_error_message() {
  local error_message=""

  error_message+="$(stdlib.message.get COLOUR_INITIALIZE_ERROR)\n"
  if [[ -z "${TERM}" ]]; then
    error_message+="$(stdlib.message.get COLOUR_INITIALIZE_ERROR_TERM)\n"
  fi

  builtin echo -en "${error_message}" >&2
}

stdlib.setting.colour.disable() {
  # shellcheck source=stdlib/setting/state/colour_disabled.sh
  source "${STDLIB_DIRECTORY}/setting/state/colour_disabled.sh"
  stdlib.setting.theme.load
}
