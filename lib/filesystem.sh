#!/bin/bash

# pictl filesystem library

set -eo pipefail

_filesystem_resolve_path_relative_to_cli() {
  # $1: the path to resolve

  local RPI_EXECUTION_DIRECTORY_RESOLVED_PATH

  pushd "${RPI_EXECUTION_DIRECTORY}" > /dev/null
  RPI_EXECUTION_DIRECTORY_RESOLVED_PATH="$(realpath "${1}")"
  popd > /dev/null

  echo "${RPI_EXECUTION_DIRECTORY_RESOLVED_PATH}"
}
