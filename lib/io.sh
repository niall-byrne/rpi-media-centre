#!/bin/bash

# pictl io library

set -eo pipefail

_io_prompt() {
  # 1: the prompt to display
  # 2: the variable name to save
  # 3: optionally set to "password" to suppress output

  local FLAGS="-rp"

  if [[ "${3}" == "password" ]]; then
    FLAGS="-rsp"
  fi

  while [[ -z "${!2}" ]]; do
    # shellcheck disable=SC2229,SC2162
    read "${FLAGS}" "$1" "$2"
    if [[ "${3}" == "password" ]]; then
      echo
    fi
  done
}

_io_prompt_confirmation() {

  local RPI_IO_CONFIRMATION

  echo -n "Are you sure you wish to proceed (Y/n) ? "

  while true; do
    read -rs -n 1 RPI_IO_CONFIRMATION
    if [[ "${RPI_IO_CONFIRMATION}" == "n" ]]; then
      echo ""
      return 127
    fi
    if [[ "${RPI_IO_CONFIRMATION}" == "Y" ]]; then
      echo ""
      return 0
    fi
  done
}
