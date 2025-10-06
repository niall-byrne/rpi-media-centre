#!/bin/bash

# pictl cli build completion library

set -eo pipefail

_cli_compiler_build_completion() {
  # shellcheck disable=SC2034
  local RPI_CLI_COMPILER_COMPLETION_GENERATED_CODE=""

  _cli_compiler_build_make_target_folder
  _cli_compiler_build_generate_target_completion

  stdlib.security.path.secure "${RPI_PATH_COMPILED_COMPLETION}" \
    "root" \
    "root" \
    "644"

  _cli_log_notice "Add the following to your .bashrc file to activate:"
  echo "  source $(realpath "${RPI_PATH_COMPILED_COMPLETION}")"
}
