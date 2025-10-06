#!/bin/bash

# pictl cli compiler generate buffer library

set -eo pipefail

_cli_compiler_build_generate_buffer_append() {
  RPI_CLI_COMPILER_BUFFER="${RPI_CLI_COMPILER_BUFFER}${FILE_LINE}"$'\n'
}

_cli_compiler_build_generate_buffer_assign() {
  # $1: the variable name to assign the buffer to

  printf -v "${1}" '%s' "${RPI_CLI_COMPILER_BUFFER%?}"
}

_cli_compiler_build_generate_buffer_clear() {
  RPI_CLI_COMPILER_BUFFER=""
}
