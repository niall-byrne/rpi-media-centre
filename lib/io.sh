#!/bin/bash

# pictl io library

set -eo pipefail

RPI_IO_COLOUR_FORCE_BOOLEAN=""

_io_colours_escape() {
  local RPI_THEME_COMPONENT
  local RPI_THEME_COMPONENTS_MERGED_SET=("${RPI_THEME_COMPONENTS[@]}" "${RPI_LOGGER_THEME_COMPONENTS[@]}" "THEME_NC")

  RPI_IO_COLOUR_FORCE_BOOLEAN=1 \
    _io_colours_load

  # shellcheck disable=SC2153
  for RPI_THEME_COMPONENT in "${RPI_THEME_COMPONENTS_MERGED_SET[@]}"; do
    printf -v "${RPI_THEME_COMPONENT}" '%s' "\${${RPI_THEME_COMPONENT}}"
  done
}

_io_colours_load() {
  if [[ "${RPI_COLOUR_BOOLEAN}" == "1" ]] ||
    [[ "${RPI_IO_COLOUR_FORCE_BOOLEAN}" == "1" ]]; then

    stdlib.setting.colour.enable
    _io_theme_load
  fi
}

_io_colours_unload() {
  stdlib.setting.colour.disable
  _io_theme_load
}

_io_theme_load() {
  local RPI_THEME_COMPONENT
  local RPI_THEME_COMPONENTS=("${RPI_THEME_COMPONENTS[@]}" "${RPI_LOGGER_THEME_COMPONENTS[@]}" "THEME_NC")
  local RPI_TRANSLATED_COLOUR

  # shellcheck disable=SC2034
  THEME_NC="NC"

  # shellcheck source=/dev/null
  source "${RPI_WORKING_DIRECTORY}/lib/cli/theme/${RPI_COLOUR_THEME}.sh"

  for RPI_THEME_COMPONENT in "${RPI_LOGGER_THEME_COMPONENTS[@]}"; do
    [[ -n "${!RPI_THEME_COMPONENT}" ]] || continue
    printf -v "STDLIB_${RPI_THEME_COMPONENT}" '%s' "${!RPI_THEME_COMPONENT}"
  done

  for RPI_THEME_COMPONENT in "${RPI_THEME_COMPONENTS[@]}"; do
    [[ -n "${!RPI_THEME_COMPONENT}" ]] || continue
    RPI_TRANSLATED_COLOUR="$(
      stdlib.setting.theme.get_colour "${!RPI_THEME_COMPONENT}" ||
        echo ""
    )"
    if [[ -n "${RPI_TRANSLATED_COLOUR}" ]]; then
      printf -v "${RPI_THEME_COMPONENT}" '%s' "${!RPI_TRANSLATED_COLOUR}"
    else
      printf -v "${RPI_THEME_COMPONENT}" '%s' ""
    fi
  done
}
