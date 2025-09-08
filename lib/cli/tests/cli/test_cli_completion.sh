#!/bin/bash

_setup_mocks() {
  local realpath_output="${1}"

  _mock.create _cli_make_build_folder
  _mock.create _cli_compiler_completion
  _mock.create stdlib.security.path.secure
  _mock.create _cli_log_notice
  _mock.create realpath

  realpath.mock.set.stdout "${realpath_output}"
}

@parametrize_with_paths() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_PATH" \
    "path_with_tilda;~/.config/completion.sh;" \
    "path_with_dots;../../completion.sh;" \
    "regular_path;/tmp/completion.sh;"
}

@parametrize_with_users() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_USER;TEST_GROUP" \
    "user1;user1;group1" \
    "user2;user2;group2"
}

test_cli_completion__@vary__calls_make_build_folder() {
  local RPI_PATH_COMPILED_COMPLETION="${TEST_PATH}"

  _setup_mocks "${TEST_PATH}"

  _cli_completion > /dev/null

  _cli_make_build_folder.mock.assert_called_once_with ""
}

@parametrize_with_paths \
  test_cli_completion__@vary__calls_make_build_folder

test_cli_completion__@vary__calls_compiler_completion() {
  local RPI_PATH_COMPILED_COMPLETION="${TEST_PATH}"

  _setup_mocks "${TEST_PATH}"

  _cli_completion > /dev/null

  _cli_compiler_completion.mock.assert_called_once_with ""
}

@parametrize_with_paths \
  test_cli_completion__@vary__calls_compiler_completion

# shellcheck disable=SC2034
test_cli_completion__@vary__@vary__calls_path_secure() {
  local RPI_PATH_COMPILED_COMPLETION="${TEST_PATH}"
  local RPI_SVC_USERNAME="${TEST_USER}"
  local RPI_SVC_GROUPNAME="${TEST_GROUP}"

  _setup_mocks "${TEST_PATH}"

  _cli_completion > /dev/null

  stdlib.security.path.secure.mock.assert_called_once_with \
    "1(${TEST_PATH}) 2(${TEST_USER}) 3(${TEST_GROUP}) 4(644)"
}

@parametrize.compose \
  test_cli_completion__@vary__@vary__calls_path_secure \
  @parametrize_with_paths \
  @parametrize_with_users

test_cli_completion__@vary__calls_log_notice() {
  local RPI_PATH_COMPILED_COMPLETION="${TEST_PATH}"

  _setup_mocks "${TEST_PATH}"

  _cli_completion > /dev/null

  _cli_log_notice.mock.assert_called_once_with \
    "1(Add the following to your .bashrc file to activate:)"
}

@parametrize_with_paths \
  test_cli_completion__@vary__calls_log_notice

# shellcheck disable=SC2034
test_cli_completion__@vary__prints_correct_source_command() {
  local RPI_PATH_COMPILED_COMPLETION="${TEST_PATH}"

  _setup_mocks "${TEST_PATH}"

  _capture.stdout _cli_completion

  assert_output "  source ${TEST_PATH}"
}

@parametrize_with_paths \
  test_cli_completion__@vary__prints_correct_source_command
