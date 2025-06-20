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
