#!/bin/bash

load "${RPI_WORKING_DIRECTORY}/lib/testing/tests/assertions/capture.sh"

test_snapshot__file_does_not_exist__fails() {
  TEST_OUTPUT="searching for a match"

  _capture_assertion_failure assert_snapshot "non_existent_file"

  assert_equals \
    " the file 'non_existent_file' does not exist" \
    "${TEST_OUTPUT}"
}

test_snapshot__file_exists__________does_not_match__fails() {
  TEST_OUTPUT="searching for a match"

  _capture_assertion_failure assert_snapshot "__fixtures__/snapshot_example.txt"

  assert_equals \
    " the contents of '__fixtures__/snapshot_example.txt' does not match the received output
 expected [simple snapshot example] but was [searching for a match]" \
    "${TEST_OUTPUT}"
}

test_snapshot__file_exists__________matches_________succeeds() {
  TEST_OUTPUT="simple snapshot example"

  assert_snapshot "__fixtures__/snapshot_example.txt"
}
