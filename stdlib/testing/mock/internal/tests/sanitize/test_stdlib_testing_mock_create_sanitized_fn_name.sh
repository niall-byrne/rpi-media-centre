#!/bin/bash

@parametrize_with_sanitize_cases() {
  @parametrize \
    "${1}" \
    "TEST_FN_NAME;TEST_EXPECTED_OUTPUT" \
    "replaces_at_sign;my@func;my____at_sign____func_sanitized" \
    "replaces_dash;my-func;my____dash____func_sanitized" \
    "replaces_dot;my.func;my____dot____func_sanitized" \
    "replaces_multiple_chars;my.fun-c@t;my____dot____fun____dash____c____at_sign____t_sanitized" \
    "no_special_chars;myfunc;myfunc_sanitized" \
    "empty_string;;_sanitized"
}

test_stdlib_testing_mock_create_sanitized_fn_name__@vary() {
  _capture.stdout __mock.create_sanitized_fn_name "${TEST_FN_NAME}"

  assert_output "${TEST_EXPECTED_OUTPUT}"
}

@parametrize_with_sanitize_cases \
  test_stdlib_testing_mock_create_sanitized_fn_name__@vary
