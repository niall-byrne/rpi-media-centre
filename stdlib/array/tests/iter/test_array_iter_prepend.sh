#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

# shellcheck disable=SC2034
test_stdlib_array_iter_prepend__no_args________returns_status_code_127() {
  _capture.rc stdlib.array.iter.prepend

  assert_rc "127"
}

# shellcheck disable=SC2034
test_stdlib_array_iter_prepend__extra_arg______returns_status_code_127() {
  local test_array=("1" "2" "3")

  _capture.rc stdlib.array.iter.prepend " " "test_array" "extra_arg"

  assert_rc "127"
}

# shellcheck disable=SC2034
test_stdlib_array_iter_prepend__empty_string___returns_status_code_126() {
  local test_array=("1" "2" "3")

  _capture.rc stdlib.array.iter.prepend "" "test_array"

  assert_rc "126"
}

# shellcheck disable=SC2034
test_stdlib_array_iter_prepend__not_array______returns_126() {
  local not_array="123"

  _capture.rc stdlib.array.iter.prepend " " "not_array"

  assert_rc "126"
}

# shellcheck disable=SC2034
test_stdlib_array_iter_prepend__not_array______logs_error() {
  local not_array="123"

  _capture.rc stdlib.array.iter.prepend " " "not_array"

  stdlib.logger.error.mock.assert_called_once_with \
    "The value 'not_array' is not an array!"
}

# shellcheck disable=SC2034
test_stdlib_array_iter_prepend__simple_array___returns_0() {
  local test_array=("1" "2" "3")

  _capture.rc stdlib.array.iter.prepend " " "test_array"

  assert_rc "0"
}

# shellcheck disable=SC2034
test_stdlib_array_iter_prepend__simple_array___updates_array() {
  local test_array=("1" "2" "3")
  local expected_array=("a1" "a2" "a3")

  stdlib.array.iter.prepend "a" "test_array"

  assert_array_equals expected_array test_array
}

# shellcheck disable=SC2034
test_stdlib_array_iter_prepend__complex_array__updates_array() {
  local test_array=("1" "2" "3")
  local expected_array=("; \n 1" "; \n 2" "; \n 3")

  stdlib.array.iter.prepend "; \n " "test_array"

  assert_array_equals expected_array test_array
}
