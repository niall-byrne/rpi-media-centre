#!/bin/bash

@parametrize_with_incorrect_args() {
  # $1: the function to parametrize
  # $2: the function name under test

  _PARAMETRIZE_FIELD_SEPERATOR=';' @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC;TEST_EXPECTED_ERROR_MESSAGES" \
    "no args;;127;${2}: invalid arguments provided!" \
    "invalid_test_fn;invalid_test_fn|@parametrize_with_incorrect_arg;126;The function 'invalid_test_fn' cannot be parametrized.|It's name must start with 'test' and contain a '@vary' tag, please rename this function!" \
    "invalid_parametrizer;test_fn_mock_@vary|invalid_parametrizer;126;The function 'invalid_parametrizer' cannot be used in a parametrize series!|It's name must be prefixed with '@parametrize_with_' !" \
    "non_existent_test_fn;non_existent_test_fn|@parametrize_with_incorrect_arg;126;The function 'non_existent_test_fn' cannot be parametrized.|It does not exist!" \
    "non_existent_parametrizer;test_fn_mock_@vary|@parametrize_with_non_existent;126;The function '@parametrize_with_non_existent' cannot be used in a parametrize series!|It does not exist!"
}
