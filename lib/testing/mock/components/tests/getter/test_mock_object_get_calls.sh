#!/bin/bash

test_mock_object__get.calls__not_called___________returns_correct_value() {
  _mock.create test_mock

  assert_equals "" "$(test_mock.mock.get.calls)"
}

test_mock_object__get.calls__called_with_digits___returns_correct_value() {
  _mock.create test_mock
  test_mock 1 2 3
  test_mock 4 5 6

  assert_equals "1 2 3"$'\n'"4 5 6" "$(test_mock.mock.get.calls)"
}

test_mock_object__get.calls__called_with_strings__returns_correct_value() {
  _mock.create test_mock
  test_mock "one two three"
  test_mock "four five six"

  assert_equals "one two three"$'\n'"four five six" "$(test_mock.mock.get.calls)"
}

test_mock_object__get.calls__called_with_strings_containing_newlines__returns_correct_value() {
  _mock.create test_mock
  test_mock "one two"$'\n'"three"
  test_mock "four five"$'\n'"six"

  assert_equals "one two"$'\n'"three"$'\n'"four five"$'\n'"six" "$(test_mock.mock.get.calls)"
}

test_mock_object__get.calls__called_with_complex_strings__returns_correct_value() {
  _mock.create test_mock
  test_mock "call 1; call1"$'\n'"call1 call1 \'\";"
  test_mock "call 2; call2"$'\n'"call2 call2 \'\";"
  test_mock "call 3; call3"$'\n'"call3 call3 \'\";"

  assert_equals \
    "call 1; call1
call1 call1 \'\";
call 2; call2
call2 call2 \'\";
call 3; call3
call3 call3 \'\";" \
    "$(test_mock.mock.get.calls)"
}
