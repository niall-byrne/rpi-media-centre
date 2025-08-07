#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

test_stdlib_array_get_last__no_args_______returns_status_code_127() {
  _capture.rc stdlib.array.get.last

  assert_rc "127"
}

# shellcheck disable=SC2034
test_stdlib_array_get_last__extra_arg_____returns_status_code_127() {
  local test_array=()

  _capture.rc stdlib.array.get.last "test_array" "extra_arg"

  assert_rc "127"
}

# shellcheck disable=SC2034
test_stdlib_array_get_last__not_array_____returns_status_code_126() {
  local not_array="123"

  _capture.rc stdlib.array.get.last "not_array"

  assert_rc "126"
}

# shellcheck disable=SC2034
test_stdlib_array_get_last__empty_array___returns_status_code_126() {
  local test_array=()

  _capture.rc stdlib.array.get.last "test_array"

  assert_rc "126"
}

# shellcheck disable=SC2034
test_stdlib_array_get_last__simple_array__returns_status_code_0() {
  local test_array=("1" "2" "3")

  _capture.rc _capture.output stdlib.array.get.last "test_array"

  assert_rc "0"
}

# shellcheck disable=SC2034
test_stdlib_array_get_last__simple_array__returns_last_element() {
  local test_array=("1" "2" "3")

  _capture.output stdlib.array.get.last "test_array"

  assert_output "3"
}
