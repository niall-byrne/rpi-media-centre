#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

test_stdlib_array_get_shortest__no_args______returns_status_code_127() {
  _capture_rc stdlib.array.get.shortest

  assert_rc "127"
}

# shellcheck disable=SC2034
test_stdlib_array_get_shortest__extra_arg____returns_status_code_127() {
  local test_array=("a" "bb" "ccc" "d" "fffff")

  _capture_rc stdlib.array.get.shortest "test_array" "extra_arg"

  assert_rc "127"
}

# shellcheck disable=SC2034
test_stdlib_array_get_shortest__not_array____returns_status_code_126() {
  local not_array="123"

  _capture_rc stdlib.array.get.shortest "not_array"

  assert_rc "126"
}

# shellcheck disable=SC2034
test_stdlib_array_get_shortest__empty_array__returns_status_code_126() {
  local test_array=()

  _capture_rc _capture_output stdlib.array.get.shortest "test_array"

  assert_rc "126"
}

# shellcheck disable=SC2034
test_stdlib_array_get_shortest__empty_array__logs_error() {
  local test_array=()

  _capture_rc stdlib.array.get.shortest "test_array"

  stdlib.logger.error.mock.assert_called_once_with \
    "The array 'test_array' is empty!"
}

# shellcheck disable=SC2034
test_stdlib_array_get_shortest__3_elements___returns_status_code_0() {
  local test_array=("a" "bb" "ccc" "d" "fffff")

  _capture_rc _capture_output stdlib.array.get.shortest "test_array"

  assert_rc "0"
}

# shellcheck disable=SC2034
test_stdlib_array_get_shortest__3_elements___returns_length_of_shortest_element() {
  local test_array=("a" "bb" "ccc" "d" "fffff")

  _capture_output stdlib.array.get.shortest "test_array"

  assert_output "1"
}
