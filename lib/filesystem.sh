#!/bin/bash

# pictl filesystem library

set -eo pipefail

_filesystem_check_exists() {
  # $1: the path to check

  if [[ ! -e "${1}" ]]; then
    {
      echo "The path '${1}' does not exist on the filesystem!"
    } >&2
    return 127
  fi
}

_filesystem_check_does_not_exist() {
  # $1: the path to check

  if [[ -e "${1}" ]]; then
    {
      echo "The path '${1}' already exists on the filesystem!"
    } >&2
    return 127
  fi
}

_filesystem_check_is_folder() {
  # $1: the folder to check

  if [[ ! -d "${1}" ]]; then
    {
      echo "The folder '${1}' is not a valid filesystem folder."
    } >&2
    return 127
  fi
}

_filesystem_resolve_path_relative_to_cli() {
  # $1: the path to resolve

  local RPI_EXECUTION_DIRECTORY_RESOLVED_PATH

  pushd "${RPI_EXECUTION_DIRECTORY}" > /dev/null
  RPI_EXECUTION_DIRECTORY_RESOLVED_PATH="$(realpath "${1}")"
  popd > /dev/null

  echo "${RPI_EXECUTION_DIRECTORY_RESOLVED_PATH}"
}
