#!/bin/bash

setup() {
  _mock.create _debug_with
  _mock.create rm
  _mock.create stdlib.io.path.query.is_exists
}

# shellcheck disable=SC2034
test_cleanup__empty_array______does_not_call_debug() {
  local RPI_EXIT_CLEANUP_PATHS=()

  _trap_cleanup

  _debug_with.mock.assert_not_called
}

# shellcheck disable=SC2034
test_cleanup__empty_array______does_not_call_rm() {
  local RPI_EXIT_CLEANUP_PATHS=()

  _trap_cleanup

  rm.mock.assert_not_called
}

# shellcheck disable=SC2034
test_cleanup__populated_array__when_some_paths_exists__calls_debug() {
  local RPI_EXIT_CLEANUP_PATHS=("file1" "file2" "file3")

  stdlib.io.path.query.is_exists.mock.set.side_effects \
    "return 0" \
    "return 1" \
    "return 0"

  _trap_cleanup

  _debug_with.mock.assert_calls_are \
    "1(_cli_log_warning) 2(TRAP: removing 'file1' ...)" \
    "1(_cli_log_warning) 2(TRAP: removing 'file3' ...)"
}

# shellcheck disable=SC2034
test_cleanup__populated_array__when_some_paths_exists__calls_rm() {
  local RPI_EXIT_CLEANUP_PATHS=("file1" "file2" "file3")

  stdlib.io.path.query.is_exists.mock.set.side_effects \
    "return 0" \
    "return 1" \
    "return 0"

  _trap_cleanup

  rm.mock.assert_calls_are \
    "1(-f) 2(file1)" \
    "1(-f) 2(file3)"
}
