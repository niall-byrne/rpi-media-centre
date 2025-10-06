#!/bin/bash

# pictl cli build cli library

set -eo pipefail

_cli_compiler_build_cli() {
  # $1: an option to force compilation

  # shellcheck disable=SC2034
  local RPI_CLI_COMPILER_GENERATED_CODE=""
  # shellcheck disable=SC2034
  local RPI_CLI_COMPILER_FORCED_BOOLEAN="${1:-"0"}"

  if _cli_compiler_query_is_compilation_required; then

    if ! _cli_compiler_query_is_compilation_memory_only; then
      _cli_compiler_build_make_target_folder
    fi

    _cli_compiler_build_generate_target_cli

    # shellcheck disable=SC2034
    RPI_CLI_JUST_COMPILED_BOOLEAN="1"
  fi

  if ! _cli_compiler_query_is_compilation_memory_only; then
    stdlib.security.path.secure "${RPI_PATH_COMPILED_CLI}" \
      "root" \
      "root" \
      "640"

    # shellcheck source=/dev/null
    source "${RPI_PATH_COMPILED_CLI}"
  fi
}
