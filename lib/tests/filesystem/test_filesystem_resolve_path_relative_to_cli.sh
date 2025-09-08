#!/bin/bash

@parametrize_with_relative_paths() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_PATH;TEST_EXECUTION_DIRECTORY;TEST_EXPECTED_RESOLVED_PATH" \
    "absolute_path____;/tmp;/var/log;/tmp" \
    "relative_path____;../../mnt;/var/log;/mnt" \
    "relative_filename;filename;/var/log;/var/log/filename"
}

# shellcheck disable=SC2034
test_filesystem_resolve_path_relative_to_cli__@vary__resolves_correctly() {
  local RPI_EXECUTION_DIRECTORY="${TEST_EXECUTION_DIRECTORY}"

  _capture.output _filesystem_resolve_path_relative_to_cli "${TEST_PATH}"

  assert_output "${TEST_EXPECTED_RESOLVED_PATH}"
}

@parametrize_with_relative_paths \
  test_filesystem_resolve_path_relative_to_cli__@vary__resolves_correctly
