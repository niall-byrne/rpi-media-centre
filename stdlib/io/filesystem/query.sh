#!/bin/bash

# stdlib io filesystem query library

set -eo pipefail

stdlib.io.filesystem.query.exists() {
  # $1: the path to check

  [[ "${#@}" == "1" ]] || return 127
  [[ -n "${1}" ]] || return 126
  test -e "${1}" || return 1
}

stdlib.io.filesystem.query.is_folder() {
  # $1: the folder to check

  [[ "${#@}" == "1" ]] || return 127
  [[ -n "${1}" ]] || return 126
  test -d "${1}" || return 1
}

stdlib.io.filesystem.query.is_file() {
  # $1: the folder to check

  [[ "${#@}" == "1" ]] || return 127
  [[ -n "${1}" ]] || return 126
  test -f "${1}" || return 1
}
