#!/bin/bash

# stdlib security root library

set -eo pipefail

stdlib.security.query.is_root_user() {

  [[ "${#@}" == "0" ]] || return 127

  if [[ "$(stdlib.security.get.euid)" != "0" ]]; then
    return 1
  fi
}
