#!/bin/bash

test_cli_pretty_string_first_char_is__arg__valid_char__no_match() {
  TEST_INPUT="baaaa"

  _capture.rc _cli_pretty_string_first_char_is "a" "${TEST_INPUT}"

  assert_rc "1"
}

test_cli_pretty_string_first_char_is__arg__valid_char__matches() {
  TEST_INPUT="baaaa"

  _capture.rc _cli_pretty_string_first_char_is "b" "${TEST_INPUT}"

  assert_rc "0"
}

test_cli_pretty_string_first_char_is__arg__invalid_char__fails() {
  TEST_INPUT="baaaa"

  _capture.rc _cli_pretty_string_first_char_is "ba" "${TEST_INPUT}"

  assert_rc "1"
}

test_cli_pretty_string_first_char_is__pipe__valid_char__no_match() {
  TEST_INPUT="baaaa"

  echo "${TEST_INPUT}" | _cli_pretty_string_first_char_is "a"

  assert_equals "1" "$?"
}

test_cli_pretty_string_first_char_is__pipe__invalid_char__fails() {
  TEST_INPUT="baaaa"

  echo "${TEST_INPUT}" | _cli_pretty_string_first_char_is "ba"

  assert_equals "1" "$?"
}

test_cli_pretty_string_first_char_is__pipe__valid_char__matches() {
  TEST_INPUT="baaaa"

  echo "${TEST_INPUT}" | _cli_pretty_string_first_char_is "b"

  assert_equals "0" "$?"
}
