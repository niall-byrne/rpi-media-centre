#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

test_stdlib_array_get_length__no_args______returns_status_code_127() {
  _capture_rc stdlib.array.get.length

  assert_rc "127"
}

# shellcheck disable=SC2034
test_stdlib_array_get_length__extra_arg____returns_status_code_127() {
  local test_array=()

  _capture_rc stdlib.array.get.length "test_array" "extra_arg"

  assert_rc "127"
}

# shellcheck disable=SC2034
test_stdlib_array_get_length__not_array____returns_status_code_126() {
  local not_array="123"

  _capture_rc stdlib.array.get.length "not_array"

  assert_rc "126"
}

# shellcheck disable=SC2034
test_stdlib_array_get_length__not_array____logs_error() {
  local not_array="123"

  _capture_rc stdlib.array.get.length "not_array"

  stdlib.logger.error.mock.assert_called_once_with \
    "The value 'not_array' is not an array!"
}

# shellcheck disable=SC2034
test_stdlib_array_get_length__empty_array__returns_status_code_0() {
  local test_array=()

  _capture_rc _capture_output stdlib.array.get.length "test_array"

  assert_rc "0"
}

# shellcheck disable=SC2034
test_stdlib_array_get_length__empty_array__returns_0() {
  local test_array=()

  _capture_output stdlib.array.get.length "test_array"

  assert_output "0"
}

# shellcheck disable=SC2034
test_stdlib_array_get_length__3_elements___returns_status_code_0() {
  local test_array=("1" "2" "3")

  _capture_rc _capture_output stdlib.array.get.length "test_array"

  assert_rc "0"
}

# shellcheck disable=SC2034
test_stdlib_array_get_length__3_elements___returns_3() {
  local test_array=("1" "2" "3")

  _capture_output stdlib.array.get.length "test_array"

  assert_output "3"
}
