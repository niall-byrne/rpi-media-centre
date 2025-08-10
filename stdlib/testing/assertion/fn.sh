#!/bin/bash
# @file fn.sh
# @brief A library of function assertions for testing.
# @description
#   This library provides function-related assertion functions for use with a testing framework like `bash_unit`.

# stdlib fn extensions to bash_unit assertions

set -eo pipefail

# @description Asserts that a variable is a function.
# @arg $1 string The name of the function to check.
assert_is_function() {
  local fn_name="${1}"

  _testing.__assertion.value.check "${fn_name}"

  if ! stdlib.fn.query.is_fn; then
    fail " '${fn_name}' is NOT a function"
  fi
}
