#!/bin/bash

setup() {
  _mock.create test_mock
  test_mock 1 2 3
  test_mock 4 5 6

  test_mock.mock.set.rc 1
  test_mock.mock.set.pipeable 0
  test_mock.mock.set.stderr stderr
  test_mock.mock.set.stdout stdout
}

test_stdlib_testing_mock_object_reset__clears_call_history() {
  test_mock.mock.reset

  assert_equals "0" "$(test_mock.mock.get.count)"
}

test_stdlib_testing_mock_object_reset__clears_rc() {
  test_mock.mock.reset

  _capture.rc test_mock > /dev/null 2>&1

  assert_equals "0" "${TEST_RC}"
}

test_stdlib_testing_mock_object_reset__clears_side_effect_with_stderr_and_stdout() {
  test_mock.mock.reset

  TEST_OUTPUT="$(test_mock 2>&1)"

  assert_equals "" "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_object_reset__clears_pipeable() {
  test_mock.mock.set.pipeable "1"

  test_mock.mock.reset

  echo "piped arg" | test_mock > /dev/null 2>&1
  assert_equals "1(piped arg)" "$(test_mock.mock.get.call "1")"
}
