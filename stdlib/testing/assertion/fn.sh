#!/bin/bash

# stdlib fn extensions to bash_unit assertions

builtin set -eo pipefail

assert_is_fn() {
  # $1: the function name to check

  local _stdlib_assertion_ouput
  local _stdlib_return_code=0

  _stdlib_assertion_output="$(__testing.protected stdlib.fn.assert.is_fn "${@}" 2>&1)" || _stdlib_return_code="$?"

  _stdlib_assertion_output="${_stdlib_assertion_output/$'\n'/$'\n '}"
  [[ "${_stdlib_return_code}" == "0" ]] || fail " ${_stdlib_assertion_output}"
}
