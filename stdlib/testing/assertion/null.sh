#!/bin/bash
# @file null.sh
# @brief A library of null assertions for testing.
# @description
#   This library provides a null assertion function for use with a testing framework like `bash_unit`.

# stdlib null extensions to bash_unit assertions

set -eo pipefail

# @description Asserts that a value is null (an empty string).
# @arg $1 string The value to check.
assert_null() {
  local test_value="${1}"

  assert_equals "" "${test_value}" "The value '${test_value}' is not null!"
}
