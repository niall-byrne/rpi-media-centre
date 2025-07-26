#!/bin/bash

load "${RPI_WORKING_DIRECTORY}/lib/testing/tests/assertions/capture.sh"

test_mock_object__assert_called_once_with__called_1_time__@vary__succeeds() {
  _mock.create test_mock
  test_mock "${TEST_VALUE}"

  test_mock.mock.assert_called_once_with "${TEST_VALUE}"
}

@parametrize \
  test_mock_object__assert_called_once_with__called_1_time__@vary__succeeds \
  "TEST_VALUE" \
  "simple__digit__,1" \
  "complex_digit__,1000" \
  "empty___simple_,," \
  "simple__string_,simple" \
  $'complex_string1,three'$'\n''three' \
  "complex_string2,two; two~~'"

test_mock_object__assert_called_once_with__called_1_time__@vary__fails() {
  _mock.create test_mock

  test_mock "non matching value"

  _capture_assertion_failure test_mock.mock.assert_called_once_with "${TEST_VALUE}"

  assert_equals \
    "Actual Call: [non matching value]"$'\n'"test_mock was not called once with '${TEST_VALUE}'"$'\n'" expected [1] but was [0]" \
    "${TEST_OUTPUT}"
}

@parametrize \
  test_mock_object__assert_called_once_with__called_1_time__@vary__fails \
  "TEST_VALUE" \
  "simple__digit__,1" \
  "complex_digit__,1000" \
  "empty___simple_,," \
  "simple__string_,simple" \
  $'complex_string1,three'$'\n''three' \
  "complex_string2,two; two~~'"

test_mock_object__assert_called_once_with__multple_calls__@vary__fails() {
  _mock.create test_mock
  test_mock 2
  test_mock 2
  test_mock 3
  test_mock 3
  test_mock 3

  _capture_assertion_failure test_mock.mock.assert_called_once_with "${TEST_VALUE}"

  assert_equals \
    "test_mock was called 5 time(s)"$'\n'" expected [1] but was [5]" \
    "${TEST_OUTPUT}"
}

@parametrize \
  test_mock_object__assert_called_once_with__multple_calls__@vary__fails \
  "TEST_VALUE,EXPECTED_COUNT" \
  "not_called_______empty_string,"",0" \
  "not_called_______string______,0,0" \
  "called_2_times___number______,2,2" \
  "called_3_times___string______,3,3"
