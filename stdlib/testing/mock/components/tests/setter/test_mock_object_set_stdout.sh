#!/bin/bash

test_mock_object__set.stdout__@vary__generates_correct_output() {
  _mock.create test_mock
  test_mock.mock.set.stdout "${EXPECTED_STDOUT}"
  test_mock.mock.set.stderr "not required"

  TEST_OUTPUT="$(test_mock 2> /dev/null)"

  assert_equals "${EXPECTED_STDOUT}" "${TEST_OUTPUT}"
}

@parametrize \
  "test_mock_object__set.stdout__@vary__generates_correct_output" \
  "EXPECTED_STDOUT" \
  "string1;string1" \
  "string2;string2"
