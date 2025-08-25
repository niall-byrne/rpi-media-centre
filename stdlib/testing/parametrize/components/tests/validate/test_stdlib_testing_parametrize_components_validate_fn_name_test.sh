#!/bin/bash

setup() {
  _mock.create _testing.error
  _mock.create invalid_name__@vary
  _mock.create invalid_name
  _mock.create test_invalid_name
  _mock.create test_valid_name__@vary
}

test_parametrize_components_validate_fn_name_test__not_a_test_function__has_vary_tag__does_not_exist__generates_error_message() {
  @parametrize._components.validate.fn_name.test "non_existent__@vary"

  _testing.error.mock.assert_calls_are \
    "1($(_testing.message.get PARAMETRIZE_ERROR_TEST_FN_INVALID "non_existent__@vary"))" \
    "1($(_testing.message.get PARAMETRIZE_ERROR_FN_DOES_NOT_EXIST))"
}

test_parametrize_components_validate_fn_name_test__not_a_test_function__has_vary_tag__exists__________generates_error_message() {
  @parametrize._components.validate.fn_name.test "invalid_name__@vary"

  _testing.error.mock.assert_calls_are \
    "1($(_testing.message.get PARAMETRIZE_ERROR_TEST_FN_INVALID "invalid_name__@vary"))" \
    "1($(_testing.message.get PARAMETRIZE_ERROR_TEST_FN_NAME))"
}

test_parametrize_components_validate_fn_name_test__not_a_test_function__no_vary_tag___does_not_exist__generates_error_message() {
  @parametrize._components.validate.fn_name.test "non_existent"

  _testing.error.mock.assert_calls_are \
    "1($(_testing.message.get PARAMETRIZE_ERROR_TEST_FN_INVALID "non_existent"))" \
    "1($(_testing.message.get PARAMETRIZE_ERROR_FN_DOES_NOT_EXIST))"
}

test_parametrize_components_validate_fn_name_test__is_test_function_____no_vary_tag___exists__________generates_error_message() {
  @parametrize._components.validate.fn_name.test "test_invalid_name"

  _testing.error.mock.assert_calls_are \
    "1($(_testing.message.get PARAMETRIZE_ERROR_TEST_FN_INVALID "test_invalid_name"))" \
    "1($(_testing.message.get PARAMETRIZE_ERROR_TEST_FN_NAME))"
}

test_parametrize_components_validate_fn_name_test__is_test_function_____no_vary_tag___does_not_exist__generates_error_message() {
  @parametrize._components.validate.fn_name.test "test_non_existent"

  _testing.error.mock.assert_calls_are \
    "1($(_testing.message.get PARAMETRIZE_ERROR_TEST_FN_INVALID "test_non_existent"))" \
    "1($(_testing.message.get PARAMETRIZE_ERROR_FN_DOES_NOT_EXIST))"
}

test_parametrize_components_validate_fn_name_test__not_a_test_function__no_vary_tag___generates_error_message() {
  @parametrize._components.validate.fn_name.test "invalid_name"

  _testing.error.mock.assert_calls_are \
    "1($(_testing.message.get PARAMETRIZE_ERROR_TEST_FN_INVALID "invalid_name"))" \
    "1($(_testing.message.get PARAMETRIZE_ERROR_TEST_FN_NAME))"
}

test_parametrize_components_validate_fn_name_test__is_test_function_____has_vary_tag__does_not_exist__generates_error_message() {
  @parametrize._components.validate.fn_name.test "test_non_existent__@vary"

  _testing.error.mock.assert_calls_are \
    "1($(_testing.message.get PARAMETRIZE_ERROR_TEST_FN_INVALID "test_non_existent__@vary"))" \
    "1($(_testing.message.get PARAMETRIZE_ERROR_FN_DOES_NOT_EXIST))"
}

test_parametrize_components_validate_fn_name_test__is_test_function_____has_vary_tag__exists___________does_not_generate_an_error() {
  @parametrize._components.validate.fn_name.test "test_valid_name__@vary"

  _testing.error.mock.assert_not_called
}
