#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

# shellcheck disable=SC2034
test_stdlib_array_iter_append__no_args________returns_status_code_127() {
  _capture.rc stdlib.array.iter.append

  assert_rc "127"
}

# shellcheck disable=SC2034
test_stdlib_array_iter_append__extra_arg______returns_status_code_127() {
  local test_array=("1" "2" "3")

  _capture.rc stdlib.array.iter.append " " "test_array" "extra_arg"

  assert_rc "127"
}

# shellcheck disable=SC2034
test_stdlib_array_iter_append__empty_string___returns_status_code_126() {
  local test_array=("1" "2" "3")

  _capture.rc stdlib.array.iter.append "" "test_array"

  assert_rc "126"
}

# shellcheck disable=SC2034
test_stdlib_array_iter_append__not_array______returns_status_code_126() {
  local not_array="123"

  _capture.rc stdlib.array.iter.append " " "not_array"

  assert_rc "126"
}

# shellcheck disable=SC2034
test_stdlib_array_iter_append__not_array______logs_error() {
  local not_array="123"

  _capture.rc stdlib.array.iter.append " " "not_array"

  stdlib.logger.error.mock.assert_called_once_with \
    "The value 'not_array' is not an array!"
}

# shellcheck disable=SC2034
test_stdlib_array_iter_append__simple_array___returns_status_code_0() {
  local test_array=("1" "2" "3")

  _capture.rc stdlib.array.iter.append " " "test_array"

  assert_rc "0"
}

# shellcheck disable=SC2034
test_stdlib_array_iter_append__simple_array___updates_array() {
  local test_array=("1" "2" "3")
  local expected_array=("1a" "2a" "3a")

  stdlib.array.iter.append "a" "test_array"

  assert_array_equals expected_array test_array
}

# shellcheck disable=SC2034
test_stdlib_array_iter_append__complex_array__updates_array() {
  local test_array=("1" "2" "3")
  local expected_array=("1; \n " "2; \n " "3; \n ")

  stdlib.array.iter.append "; \n " "test_array"

  assert_array_equals expected_array test_array
}
