#!/bin/bash

setup() {
  _mock.create stdlib.security.path.make.dir
}

@parametrize_with_paths() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_PATH" \
    "path_with_tilda;~/.config;" \
    "path_with_dots;../..;" \
    "regular_path;/tmp/build;"
}

# shellcheck disable=SC2034
test_cli_make_build_folder__@vary__creates_directory_with_correct_parameters() {
  local RPI_PATH_COMPILED_ROOT="${TEST_PATH}"

  _cli_make_build_folder

  stdlib.security.path.make.dir.mock.assert_called_once_with \
    "1(${TEST_PATH}) 2(root) 3(root) 4(755)"
}

@parametrize_with_paths \
  test_cli_make_build_folder__@vary__creates_directory_with_correct_parameters
