#!/bin/bash

# stdlib io path query is library

builtin set -eo pipefail

stdlib.io.path.query.is_exists() {
  # $1: the path to check

  [[ "${#@}" == "1" ]] || return 127
  [[ -n "${1}" ]] || return 126
  stdlib.builtin.overridable test -e "${1}" || return 1
}

stdlib.io.path.query.is_file() {
  # $1: the folder to check

  [[ "${#@}" == "1" ]] || return 127
  [[ -n "${1}" ]] || return 126
  stdlib.builtin.overridable test -f "${1}" || return 1
}

stdlib.io.path.query.is_folder() {
  # $1: the folder to check

  [[ "${#@}" == "1" ]] || return 127
  [[ -n "${1}" ]] || return 126
  stdlib.builtin.overridable test -d "${1}" || return 1
}
