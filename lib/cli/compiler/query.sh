#!/bin/bash

# pictl cli compiler query library

set -eo pipefail

_cli_compiler_query_is_compilation_memory_only() {
  [[ "${RPI_CLI_MEMORY_ONLY_BOOLEAN}" == "1" ]]
}

_cli_compiler_query_is_compilation_forced() {
  [[ "${RPI_CLI_COMPILER_FORCED_BOOLEAN}" == "1" ]] &&
    [[ "${RPI_CLI_JUST_COMPILED_BOOLEAN}" != "1" ]]
}

_cli_compiler_query_is_compilation_required() {
  if _cli_compiler_query_is_compilation_forced; then
    echo "CLI compilation has been requested ..."
    return 0
  fi

  if _cli_compiler_query_is_compilation_memory_only; then
    echo "CLI is running in configured for memory only, compilation required..."
    return 0
  fi

  if ! _cli_compiler_query_is_existing_cli_compatible; then
    return 0
  fi

  return 1
}

_cli_compiler_query_is_existing_cli_compatible() {
  if [[ ! -f "${RPI_PATH_COMPILED_CLI}" ]]; then
    echo "No existing CLI, compiling ..."
    return 1
  fi

  return 0
}
