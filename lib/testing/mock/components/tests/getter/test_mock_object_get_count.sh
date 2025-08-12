#!/bin/bash

test_mock_object__get.count__not_called___________returns_correct_value() {
  _mock.create test_mock

  assert_equals "0" "$(test_mock.mock.get.count)"
}

test_mock_object__get.count__called_with_digits___returns_correct_value() {
  _mock.create test_mock
  test_mock 1 2 3
  test_mock 4 5 6

  assert_equals "2" "$(test_mock.mock.get.count)"
}

test_mock_object__get.count__called_with_strings__returns_correct_value() {
  _mock.create test_mock
  test_mock "one two three"
  test_mock "four five six"
  test_mock "seven eight nine"

  assert_equals "3" "$(test_mock.mock.get.count)"
}

test_mock_object__get.count__called_with_strings_containing_newlines__returns_correct_value() {
  _mock.create test_mock
  test_mock "one two"$'\n'"three"
  test_mock "four five"$'\n'"six"
  test_mock "seven eight"$'\n'"nine"

  assert_equals "3" "$(test_mock.mock.get.count)"
}
