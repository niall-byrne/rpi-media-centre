#!/bin/bash

setup() {
  _mock.create ls
  _mock.create pushd
  _mock.create popd
}

@parametrize_with_command_return_codes() {
  # $1: the test to parametrize

  @parametrize \
    "${1}" \
    "TEST_TARGET_DIRECTORY;TEST_COMMAND_RETURN_CODE" \
    "127_parent_directory;..;127" \
    "9_root_etc_directory;/etc;9" \
    "0_root_mnt_directory;/mnt;0"
}

test_control_push__command_returns_@vary__call_returns_same_status_code() {

  ls.mock.set.rc "${TEST_COMMAND_RETURN_CODE}"

  _capture.rc _control_pushd "${TEST_TARGET_DIRECTORY}" ls

  assert_rc "${TEST_COMMAND_RETURN_CODE}"
}

@parametrize_with_command_return_codes \
  test_control_push__command_returns_@vary__call_returns_same_status_code

test_control_push__command_returns_@vary__changes_directory_as_requestd() {

  ls.mock.set.rc "${TEST_COMMAND_RETURN_CODE}"

  _control_pushd "${TEST_TARGET_DIRECTORY}" ls

  pushd.mock.assert_called_once_with "1(${TEST_TARGET_DIRECTORY})"
  popd.mock.assert_called_once_with ""
}

@parametrize_with_command_return_codes \
  test_control_push__command_returns_@vary__changes_directory_as_requestd
