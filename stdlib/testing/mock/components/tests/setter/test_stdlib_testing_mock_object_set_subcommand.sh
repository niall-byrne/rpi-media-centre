#!/bin/bash

test_stdlib_testing_mock_object_set_subcommand__@vary__calls_subcommand_as_expected() {
  _mock.create test_mock
  _mock.create curl
  curl.mock.set.stdout "simulating file download..."

  test_mock.mock.set.subcommand "${SIDE_EFFECT_FUNCTION}"

  TEST_OUTPUT="$(test_mock "arg1" "arg2" "arg3")"

  assert_equals "${EXPECTED_STDOUT}" "${TEST_OUTPUT}"
}

@parametrize \
  test_stdlib_testing_mock_object_set_subcommand__@vary__calls_subcommand_as_expected \
  "SIDE_EFFECT_FUNCTION;EXPECTED_STDOUT" \
  "complex_echo;echo \\\$*;arg1 arg2 arg3" \
  "simple_echo_;echo \\\$1;arg1" \
  "curl_command;curl \\\$1;simulating file download..."
