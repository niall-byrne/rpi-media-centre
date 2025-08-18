#!/bin/bash

# pictl disk pretty library

set -eo pipefail

_disk_pretty_filesystem_status() {
  # $1: the input string to colourize

  local CONTENT_LINE
  local RPI_CLI_PRETTY_TITLE_BOOLEAN="0"
  local RPI_CLI_PRETTY_DEVICE_REGEX="^( *└─*|├─*|)([a-z0-9_]*)"
  local RPI_CLI_PRETTY_FREE_REGEX="([0-9]+\.[0-9]+[GKMT]+)"
  local RPI_CLI_PRETTY_PERCENT_REGEX="([0-9]+)%"

  while IFS= read -r CONTENT_LINE; do

    if [[ "${RPI_CLI_PRETTY_TITLE_BOOLEAN}" == "0" ]]; then
      _cli_pretty_colour_var "HEADER" "CONTENT_LINE"
      RPI_CLI_PRETTY_TITLE_BOOLEAN="1"

    elif [[ "${CONTENT_LINE}" =~ ${RPI_CLI_PRETTY_DEVICE_REGEX} ]]; then
      [[ -n "${BASH_REMATCH[1]}" ]] && _cli_pretty_colour_substring_var "DEVICE_CONNECTORS" "${BASH_REMATCH[1]}" "CONTENT_LINE"
      [[ -n "${BASH_REMATCH[2]}" ]] && _cli_pretty_colour_substring_var "DEVICE" "${BASH_REMATCH[2]}" "CONTENT_LINE"
    fi

    if [[ "${CONTENT_LINE}" =~ ${RPI_CLI_PRETTY_FREE_REGEX} ]]; then
      [[ -n "${BASH_REMATCH[1]}" ]] && _cli_pretty_colour_substring_var "DISK_INDICATOR_SPACE_FREE" "${BASH_REMATCH[1]}" "CONTENT_LINE"
    fi

    if [[ "${CONTENT_LINE}" =~ ${RPI_CLI_PRETTY_PERCENT_REGEX} ]]; then
      if (("${BASH_REMATCH[1]}" >= "${RPI_DISK_GAUGE_THRESHOLD_CRITICAL}")); then
        _cli_pretty_colour_substring_var "DISK_GAUGE_SPACE_CRITICAL" "${BASH_REMATCH[1]}%" "CONTENT_LINE"
      elif (("${BASH_REMATCH[1]}" >= "${RPI_DISK_GAUGE_THRESHOLD_WARNING}")); then
        _cli_pretty_colour_substring_var "DISK_GAUGE_SPACE_WARNING" "${BASH_REMATCH[1]}%" "CONTENT_LINE"
      else
        _cli_pretty_colour_substring_var "DISK_GAUGE_SPACE_OK" "${BASH_REMATCH[1]}%" "CONTENT_LINE"
      fi
    fi

    echo -e "${CONTENT_LINE}"
  done <<< "${1}"
}

stdlib.fn.derive.pipeable "_disk_pretty_filesystem_status" "1"

_disk_pretty_hardware_status() {
  # $1: the input string to colourize

  local CONTENT_LINE
  local RPI_CLI_PRETTY_DEVICE_REGX="(\/dev\/[a-z]{3}):"
  local RPI_CLI_PRETTY_STATUS_ACTIVE="active/idle"
  local RPI_CLI_PRETTY_STATUS_STANDBY="standby"

  while IFS= read -r CONTENT_LINE; do

    if [[ "${CONTENT_LINE}" =~ ${RPI_CLI_PRETTY_DEVICE_REGX} ]]; then
      _cli_pretty_colour_substring_var "DEVICE" "${BASH_REMATCH[1]}" "CONTENT_LINE"
    fi

    case "${CONTENT_LINE}" in
      *"${RPI_CLI_PRETTY_STATUS_ACTIVE}"*)
        _cli_pretty_colour_substring_var "DISK_INDICATOR_ACTIVE" "${RPI_CLI_PRETTY_STATUS_ACTIVE}" "CONTENT_LINE"
        ;;
      *"${RPI_CLI_PRETTY_STATUS_STANDBY}"*)
        _cli_pretty_colour_substring_var "DISK_INDICATOR_IDLE" "${RPI_CLI_PRETTY_STATUS_STANDBY}" "CONTENT_LINE"
        ;;
    esac

    echo -e "${CONTENT_LINE}"
  done <<< "${1}"
}

stdlib.fn.derive.pipeable "_disk_pretty_hardware_status" "1"
