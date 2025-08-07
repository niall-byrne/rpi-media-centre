#!/bin/bash

test_mock_object__set.pipeable__on___accepts_input_by_pipe() {
  _mock.create test_mock
  test_mock.mock.set.pipeable "1"

  echo "test" | test_mock

  assert_equals "1" "$(test_mock.mock.get.count)"
  assert_equals "test" "$(test_mock.mock.get.call "1")"
}

test_mock_object__set.pipeable__off__ignores_input_by_pipe() {
  _mock.create test_mock
  test_mock.mock.set.pipeable "0"

  echo "test" | test_mock

  assert_equals "1" "$(test_mock.mock.get.count)"
  assert_equals "" "$(test_mock.mock.get.call "1")"
}
