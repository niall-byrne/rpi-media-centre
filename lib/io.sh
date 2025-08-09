#!/bin/bash

# pictl io library

set -eo pipefail

_io_colours_escape() {

  local RPI_IO_COLOUR_LIST
  local RPI_IO_COLOUR

  _io_colours_load "1"
  _io_theme_load

  RPI_IO_COLOUR_LIST="$(
    declare -p |
      grep '^declare -. COLOUR_\|^declare -. THEME_' |
      sed 's/^declare -. //g' |
      cut -d '=' -f 1
  )"

  for RPI_IO_COLOUR in ${RPI_IO_COLOUR_LIST}; do
    printf -v "${RPI_IO_COLOUR}" '%s' "\${${RPI_IO_COLOUR}}"
  done
}

_io_colours_load() {
  # $1: override to force loading regardless of config

  local RPI_IO_COLOUR_FORCE_BOOLEAN="${1}"
  local RPI_IO_COLOUR_LIST
  local RPI_IO_COLOUR

  if [[ "${RPI_COLOUR_BOOLEAN}" == "1" ]] ||
    [[ "${RPI_IO_COLOUR_FORCE_BOOLEAN}" == "1" ]]; then
    tput init >> /dev/null 2>&1 || return 0

    source "${RPI_WORKING_DIRECTORY}/lib/cli/theme/base_colours.sh"

    RPI_IO_COLOUR_LIST="$(
      declare -p |
        grep '^declare -. RPI_COLOUR_' |
        sed 's/^declare -. //g' |
        cut -d '=' -f 1
    )"

    for RPI_IO_COLOUR in ${RPI_IO_COLOUR_LIST}; do
      printf -v "${RPI_IO_COLOUR/RPI_/}" '%s' "${!RPI_IO_COLOUR}"
    done

    _io_theme_load
  fi
}

_io_colours_unload() {

  local RPI_IO_COLOUR_LIST
  local RPI_IO_COLOUR

  RPI_IO_COLOUR_LIST="$(
    declare -p |
      grep '^declare -. RPI_COLOUR_' |
      sed 's/^declare -. //g' |
      cut -d '=' -f 1
  )"

  for RPI_IO_COLOUR in ${RPI_IO_COLOUR_LIST}; do
    printf -v "${RPI_IO_COLOUR/RPI_/}" '%s' ""
  done

  _io_theme_load
}

_io_theme_load() {
  # shellcheck source=/dev/null
  source "${RPI_WORKING_DIRECTORY}/lib/cli/theme/${RPI_COLOUR_THEME}.sh"
  # shellcheck disable=SC2034
  THEME_NC="${COLOUR_NC}"
}
