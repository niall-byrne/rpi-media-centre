#!/bin/bash

# pictl filesystem library

set -eo pipefail

_filesystem_resolve_path_relative_to_cli() {
  # $1: the path to resolve

  local resolved_path

  pushd "${RPI_EXECUTION_DIRECTORY}" >> /dev/null
  resolved_path="$(realpath "$(realpath --relative-to "${RPI_EXECUTION_DIRECTORY}" "${1}")")"
  popd >> /dev/null

  echo "${resolved_path}"
}
