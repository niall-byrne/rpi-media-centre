#!/bin/bash

test_cli_pretty_string_starts_with__arg__no_match() {
  TEST_INPUT="aaaaa"

  _capture_rc _cli_pretty_string_starts_with "bbb" "${TEST_INPUT}"

  assert_rc "1"
}

test_cli_pretty_string_starts_with__arg__matches() {
  TEST_INPUT="aaaaa"

  _capture_rc _cli_pretty_string_starts_with "aaa" "${TEST_INPUT}"

  assert_rc "0"
}

test_cli_pretty_string_starts_with__pipe__no_match() {
  TEST_INPUT="baaaa"

  echo "${TEST_INPUT}" | _cli_pretty_string_starts_with "bbb"

  assert_equals "1" "$?"
}

test_cli_pretty_string_starts_with__pipe__matches() {
  TEST_INPUT="aaaaa"

  echo "${TEST_INPUT}" | _cli_pretty_string_starts_with "aaa"

  assert_equals "0" "$?"
}
