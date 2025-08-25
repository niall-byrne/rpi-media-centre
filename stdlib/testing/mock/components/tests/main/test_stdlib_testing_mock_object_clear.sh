#!/bin/bash

setup() {
  _mock.create test_mock
  test_mock 1 2 3
  test_mock 4 5 6

  test_mock.mock.set.rc 1
  test_mock.mock.set.subcommand "echo subcommand"
  test_mock.mock.set.pipeable 0
  test_mock.mock.set.stderr stderr
  test_mock.mock.set.stdout stdout
  test_mock.mock.set.side_effects "echo queued_1" "echo queued_2" "echo queued_3"
}

test_stdlib_testing_mock_object_clear__clears_call_history() {
  test_mock.mock.clear

  assert_equals "0" "$(test_mock.mock.get.count)"
}

test_stdlib_testing_mock_object_clear__clears_side_effects() {
  test_mock.mock.clear

  TEST_OUTPUT="$(test_mock 2>&1)"

  assert_equals "subcommand"$'\n'"stderr"$'\n'"stdout" "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_object_clear__preserves_rc() {
  test_mock.mock.clear

  _capture.rc test_mock > /dev/null 2>&1

  assert_equals "1" "${TEST_RC}"
}

test_stdlib_testing_mock_object_clear__preserves_subcommand_with_stderr_and_stdout() {
  test_mock.mock.clear

  TEST_OUTPUT="$(test_mock 2>&1)"

  assert_equals "subcommand"$'\n'"stderr"$'\n'"stdout" "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_object_clear__preserves_pipeable() {
  test_mock.mock.set.pipeable "1"

  test_mock.mock.clear

  echo "piped arg" | test_mock > /dev/null 2>&1
  assert_equals "1(piped arg)" "$(test_mock.mock.get.call "1")"
}
