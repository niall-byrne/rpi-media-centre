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

@parametrize_with_users() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_USER;TEST_GROUP" \
    "user1;user1;group1" \
    "user2;user2;group2"
}

# shellcheck disable=SC2034
test_cli_make_build_folder__@vary__@vary__creates_directory_with_correct_parameters() {
  local RPI_PATH_COMPILED_ROOT="${TEST_PATH}"
  local RPI_SVC_USERNAME="${TEST_USER}"
  local RPI_SVC_GROUPNAME="${TEST_GROUP}"

  _cli_make_build_folder

  stdlib.security.path.make.dir.mock.assert_called_once_with \
    "1(${TEST_PATH}) 2(${TEST_USER}) 3(${TEST_GROUP}) 4(755)"
}

@parametrize.compose \
  test_cli_make_build_folder__@vary__@vary__creates_directory_with_correct_parameters \
  @parametrize_with_paths \
  @parametrize_with_users
