#!/bin/bash

# pictl dependencies library

set -eo pipefail

_dependencies_enforce() {
  # $1: the external dependency binary
  # $2: the external dependency name
  # $3: a string describing how to install it

  if command -v "${1}" > /dev/null; then
    return 0
  fi
  _cli_log_error "DEPENDENCIES: ${2} is required by pictl, but it could not be found."
  echo "${3}"
  return 127
}

_dependencies_requirement_generic() {
  # $1: the required application

  _dependencies_enforce \
    "${1}" \
    "The application ${1}" \
    "Please consider running: sudo apt-get install ${1}"
}

_dependencies_requirement_awscli() {
  _dependencies_enforce \
    aws \
    "The aws cli" \
    "Please see https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html for further details"
}

_dependencies_requirement_manifest_editor() {
  if [[ "${RPI_MANIFEST_EDITOR}" == "/usr/bin/vi" ]]; then
    _dependencies_enforce \
      "${RPI_MANIFEST_EDITOR}" \
      "The application vim" \
      "Please consider running: sudo apt-get install vim"
  else
    _dependencies_enforce \
      "${RPI_MANIFEST_EDITOR}" \
      "The configured manifest editor" \
      "Please install it or review the value of RPI_MANIFEST_EDITOR."
  fi
}
