#!/bin/bash

setup() {
  _mock.create _fn_1
  _mock.create _fn_2
}

test_stdlib_testing_mock_reset_all__two_mocks_called__without_reset_all__counts_are_correct() {
  _fn_1
  _fn_2

  _fn_1.mock.assert_count_is "1"
  _fn_2.mock.assert_count_is "1"
}

test_stdlib_testing_mock_reset_all__two_mocks_called__with_reset_all_____counts_are_cleared() {
  _fn_1
  _fn_2

  _mock.reset_all

  _fn_1.mock.assert_count_is "0"
  _fn_2.mock.assert_count_is "0"
}

test_stdlib_testing_mock_reset_all__two_mocks_called__without_reset_all__implementation_is_correct() {
  _fn_1.mock.set.stdout "function 1"
  _fn_2.mock.set.stdout "function 2"

  TEST_OUTPUT="$(
    _fn_1
    _fn_2
  )"

  assert_equals "function 1"$'\n'"function 2" "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_reset_all__two_mocks_called__with_reset_all_____implementation_is_reset() {
  _fn_1.mock.set.stdout "function 1"
  _fn_2.mock.set.stdout "function 2"

  _mock.reset_all

  TEST_OUTPUT="$(
    _fn_1
    _fn_2
  )"

  assert_output_null
}
