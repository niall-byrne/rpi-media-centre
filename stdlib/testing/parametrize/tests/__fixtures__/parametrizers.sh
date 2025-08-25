#!/bin/bash

@parametrize_with_incorrect_args() {
  # $1: the function to parametrize
  # $2: the function name under test

  _PARAMETRIZE_FIELD_SEPARATOR=';' @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC;TEST_ERROR_CALL_DEFINITION;TEST_MESSAGE_ARG_DEFINITIONS" \
    "no args;;127;${2}|ARGUMENTS_INVALID;;" \
    "invalid_test_fn;invalid_test_fn|@parametrize_with_incorrect_arg;126;;PARAMETRIZE_ERROR_TEST_FN_INVALID|invalid_test_fn PARAMETRIZE_ERROR_TEST_FN_NAME" \
    "invalid_parametrizer;test_fn_mock_@vary|invalid_parametrizer;126;;PARAMETRIZE_ERROR_PARAMETRIZER_FN_INVALID|invalid_parametrizer PARAMETRIZE_ERROR_PARAMETRIZER_FN_NAME" \
    "non_existent_test_fn;non_existent_test_fn|@parametrize_with_incorrect_arg;126;;PARAMETRIZE_ERROR_TEST_FN_INVALID|non_existent_test_fn PARAMETRIZE_ERROR_FN_DOES_NOT_EXIST" \
    "non_existent_parametrizer;test_fn_mock_@vary|@parametrize_with_non_existent;126;;PARAMETRIZE_ERROR_PARAMETRIZER_FN_INVALID|@parametrize_with_non_existent PARAMETRIZE_ERROR_FN_DOES_NOT_EXIST"
}
