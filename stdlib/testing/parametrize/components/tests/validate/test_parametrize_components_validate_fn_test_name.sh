#!/bin/bash

setup() {
  _mock.create _testing.error
  _testing.error.mock.set.rc 127
}

test_parametrize_components_validate_fn_name_test__not_a_test_function__has_vary_tag__generates_error_message() {
  @parametrize._components.validate.fn_name.test "invalid_name__@vary"

  _testing.error.mock.assert_called_once_with \
    "The function 'invalid_name__@vary' cannot be parametrized.  It's name must start with 'test' and contain a '@vary' tag, please rename this function!"
}

test_parametrize_components_validate_fn_name_test__is_test_function_____no_vary_tag___generates_error_message() {
  @parametrize._components.validate.fn_name.test "test_invalid_name"

  _testing.error.mock.assert_called_once_with \
    "The function 'test_invalid_name' cannot be parametrized.  It's name must start with 'test' and contain a '@vary' tag, please rename this function!"
}

test_parametrize_components_validate_fn_name_test__not_a_test_function__no_vary_tag___generates_error_message() {
  @parametrize._components.validate.fn_name.test "invalid_name"

  _testing.error.mock.assert_called_once_with \
    "The function 'invalid_name' cannot be parametrized.  It's name must start with 'test' and contain a '@vary' tag, please rename this function!"
}

test_parametrize_components_validate_fn_name_test__is_test_function_____has_vary_tag__does_not_generate_an_error() {
  @parametrize._components.validate.fn_name.test "test_valid_name__@vary"

  _testing.error.mock.assert_not_called
}
