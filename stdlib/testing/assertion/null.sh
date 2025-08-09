#!/bin/bash

# stdlib null extensions to bash_unit assertions

set -eo pipefail

assert_null() {
  # $1: the value to check

  local test_value="${1}"

  assert_equals "" "${test_value}" "The value '${test_value}' is not null!"
}
