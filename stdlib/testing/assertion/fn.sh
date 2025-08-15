#!/bin/bash

# stdlib fn extensions to bash_unit assertions

set -eo pipefail

assert_is_fn() {
  # $1: the function name to check

  local fn_name="${1}"

  _testing.__assertion.value.check "${fn_name}"

  if ! stdlib.fn.query.is_fn "${1}"; then
    fail " '${fn_name}' is NOT a function"
  fi
}
