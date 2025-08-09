#!/bin/bash

test_mock_object__set.stderr__@vary__generates_correct_output() {
  _mock.create test_mock
  test_mock.mock.set.stderr "${EXPECTED_STDERR}"
  test_mock.mock.set.stdout "not required"

  { TEST_OUTPUT="$(test_mock 2>&1 >&3 3>&-)"; } 3> /dev/null

  assert_equals "${EXPECTED_STDERR}" "${TEST_OUTPUT}"
}

@parametrize \
  "test_mock_object__set.stderr__@vary__generates_correct_output" \
  "EXPECTED_STDERR" \
  "string1,string1" \
  "string2,string2"
