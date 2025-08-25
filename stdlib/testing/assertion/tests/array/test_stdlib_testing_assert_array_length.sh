#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

setup() {
  # shellcheck disable=SC2034
  ARRAY1=("sandwiches" "pizza" "wraps")

  _mock.create stdlib.testing.internal.logger.error
}

test_stdlib_testing_assert_array_length__args_is_a_string_______fails() {
  _capture_assertion_failure assert_array_length "3" "just a string"

  stdlib.testing.internal.logger.error.mock.assert_called_once_with \
    "1($(stdlib.message.get IS_NOT_ARRAY "just a string"))"
}

test_stdlib_testing_assert_array_length__first_arg_is_missing___fails() {
  _capture_assertion_failure assert_array_length

  assert_equals \
    " $(_testing.assert.message.get ASSERT_ERROR_INSUFFICIENT_ARGS assert_array_length)" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_assert_array_length__second_arg_is_missing__fails() {
  _capture_assertion_failure assert_array_length "3"

  assert_equals \
    " $(_testing.assert.message.get ASSERT_ERROR_INSUFFICIENT_ARGS assert_array_length)" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_assert_array_length__wrong_length_given_____fails() {
  _capture_assertion_failure assert_array_length "4" ARRAY1

  assert_equals \
    " $(_testing.assert.message.get ASSERT_ERROR_ARRAY_LENGTH_NON_MATCHING 4 3)" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_assert_array_length__correct_length_given___succeeds() {
  assert_array_length "3" ARRAY1
}
