#!/bin/bash

setup() {
  _mock.create _fn_1
  _mock.create _fn_2
}

test_stdlib_testing_mock_clear_all__two_mocks_called__without_clear_all__counts_are_correct() {
  _fn_1
  _fn_2

  _fn_1.mock.assert_count_is "1"
  _fn_2.mock.assert_count_is "1"
}

test_stdlib_testing_mock_clear_all__two_mocks_called__with_clear_all_____counts_are_cleared() {
  _fn_1
  _fn_2

  _mock.clear_all

  _fn_1.mock.assert_count_is "0"
  _fn_2.mock.assert_count_is "0"
}
