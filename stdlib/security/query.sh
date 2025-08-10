#!/bin/bash
# @file query.sh
# @brief A library for making security-related queries.
# @description
#   This library provides functions to make security-related queries,
#   such as checking if the current user is the root user.

# stdlib security root library

set -eo pipefail

# @description Checks if the current user is the root user.
# @exitcode 0 If the current user is root.
# @exitcode 1 If the current user is not root.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.security.query.is_root_user() {

  [[ "${#@}" == "0" ]] || return 127

  if [[ "$(stdlib.security.get.euid)" != "0" ]]; then
    return 1
  fi
}
