#!/bin/bash

@parametrize_with_lengths() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_REQUIRED_LENGTH" \
    "10;10" \
    "20;20"
}

test_stdlib_testing_fixtures_random__default__________________is_50_characters_long() {
  _capture.stdout _testing.fixtures.random.name

  assert_equals "50" "${#TEST_OUTPUT}"
}

test_stdlib_testing_fixtures_random__specified_@vary_characters__is_correct_length() {
  _capture.stdout _testing.fixtures.random.name "${TEST_REQUIRED_LENGTH}"

  assert_equals "${TEST_REQUIRED_LENGTH}" "${#TEST_OUTPUT}"
}

@parametrize_with_lengths \
  test_stdlib_testing_fixtures_random__specified_@vary_characters__is_correct_length

test_stdlib_testing_fixtures_random__specified_@vary_characters__is_alpha_numeric() {
  _capture.stdout _testing.fixtures.random.name "${TEST_REQUIRED_LENGTH}"

  _capture.rc stdlib.string.query.is_alpha_numeric "${TEST_OUTPUT}"

  assert_rc "0"
}

@parametrize_with_lengths \
  test_stdlib_testing_fixtures_random__specified_@vary_characters__is_alpha_numeric
