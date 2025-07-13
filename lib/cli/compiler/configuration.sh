#!/bin/bash

# pictl cli compiler configuration library

set -eo pipefail

# CLI Configuration File Settings
# shellcheck disable=SC2034
RPI_CLI_COMPILER_BEFORE_ALL_COMMAND_MARKER=">"
# shellcheck disable=SC2034
RPI_CLI_COMPILER_FIELD_SEPERATOR="|"
RPI_CLI_COMPILER_SECTION_SEPERATOR="="

_cli_compiler_configuration_load_to_buffer() {
  # $1: the compilation dispatcher to call for each section

  local FILE_LINE
  # shellcheck disable=SC2034
  local RPI_CLI_COMPILER_BUFFER=""
  local RPI_CLI_COMPILER_HEADER=""
  local RPI_CLI_COMPILER_USAGE_STRING=""
  local RPI_COMPILER_STAGE=0

  "${1}"

  while IFS= read -r FILE_LINE; do

    case "${FILE_LINE}" in
      "")
        _cli_compiler_configuration_load_to_buffer_reset_state
        _cli_compiler_buffer_clear
        ;;
      "${RPI_CLI_COMPILER_SECTION_SEPERATOR}")
        ((RPI_COMPILER_STAGE += 1))
        "${1}"
        _cli_compiler_buffer_clear
        ;;
      *)
        _cli_compiler_buffer_append
        ;;
    esac

  done < "${RPI_WORKING_DIRECTORY}/lib/cli/config"

  RPI_COMPILER_STAGE=4
  "${1}"
}

_cli_compiler_configuration_load_to_buffer_reset_state() {
  RPI_COMPILER_STAGE=0
  # shellcheck disable=SC2034
  RPI_CLI_COMPILER_HEADER=""
  # shellcheck disable=SC2034
  RPI_CLI_COMPILER_USAGE_STRING=""
}
