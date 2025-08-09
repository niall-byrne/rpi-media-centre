#!/bin/bash

# pictl cli library

set -eo pipefail

# CLI General Settings

# shellcheck disable=SC2034
RPI_PATH_FRAGMENTS="lib/cli/compiler/fragments"
RPI_PATH_COMPILED_ROOT="lib/cli/build"
RPI_PATH_COMPILED_CLI="${RPI_PATH_COMPILED_ROOT}/cli.sh"
RPI_PATH_COMPILED_COMPLETION="${RPI_PATH_COMPILED_ROOT}/bash_completion.sh"

_cli_bootstrap() {
  # $1: an option to force compilation

  # shellcheck disable=SC2034
  local RPI_CLI_COMPILER_GENERATED_CODE=""
  # shellcheck disable=SC2034
  local RPI_CLI_COMPILER_FORCED_BOOLEAN="${1:-"0"}"

  if _cli_compiler_query_is_compilation_required; then
    _cli_make_build_folder
    _cli_compiler_cli

    # shellcheck disable=SC2034
    RPI_CLI_JUST_COMPILED_BOOLEAN="1"

    stdlib.security.path.secure \
      "${RPI_PATH_COMPILED_CLI}" \
      "${RPI_SVC_USERNAME}" \
      "${RPI_SVC_GROUPNAME}" \
      "640"
  fi

  if ! _cli_compiler_query_is_compilation_memory_only; then
    # shellcheck source=/dev/null
    source "${RPI_PATH_COMPILED_CLI}"
  fi
}

_cli_completion() {
  # shellcheck disable=SC2034
  local RPI_CLI_COMPILER_COMPLETION_GENERATED_CODE=""

  _cli_make_build_folder
  _cli_compiler_completion

  stdlib.security.path.secure \
    "${RPI_PATH_COMPILED_COMPLETION}" \
    "${RPI_SVC_USERNAME}" \
    "${RPI_SVC_GROUPNAME}" \
    "644"

  _cli_log_notice "Add the following to your .bashrc file to activate:"
  echo "  source $(realpath "${RPI_PATH_COMPILED_COMPLETION}")"
}

_cli_make_build_folder() {
  stdlib.security.path.make.dir \
    "${RPI_PATH_COMPILED_ROOT}" \
    "${RPI_SVC_USERNAME}" \
    "${RPI_SVC_GROUPNAME}" \
    "755"
}
