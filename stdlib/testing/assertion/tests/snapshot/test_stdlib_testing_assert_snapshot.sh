#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

test_stdlib_testing_assert_snapshot__file_does_not_exist__fails() {
  TEST_OUTPUT="searching for a match"

  _capture_assertion_failure assert_snapshot "non_existent_file"

  assert_equals \
    " $(_testing.assert.message.get ASSERT_ERROR_FILE_NOT_FOUND "non_existent_file")" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_assert_snapshot__file_exists__________does_not_match__fails() {
  local original_test_output="searching for a match"
  TEST_OUTPUT="${original_test_output}"
  local snapshot_file
  snapshot_file='__fixtures__/snapshot_example.txt'
  local expected_content
  expected_content="$(cat "${snapshot_file}")"

  _capture_assertion_failure assert_snapshot "${snapshot_file}"

  assert_equals \
    " $(_testing.assert.message.get ASSERT_ERROR_SNAPSHOT_NON_MATCHING "${snapshot_file}")"$'\n'" expected [${expected_content}] but was [${original_test_output}]" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_assert_snapshot__file_exists__________matches_________succeeds() {
  TEST_OUTPUT=$'\n'"simple snapshot example"

  assert_snapshot "__fixtures__/snapshot_example.txt"
}
