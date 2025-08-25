#!/bin/bash

# stdlib security query user library

builtin set -eo pipefail

stdlib.security.user.query.is_root() {

  [[ "${#@}" == "0" ]] || return 127

  if [[ "$(stdlib.security.get.euid)" != "0" ]]; then
    return 1
  fi
}
