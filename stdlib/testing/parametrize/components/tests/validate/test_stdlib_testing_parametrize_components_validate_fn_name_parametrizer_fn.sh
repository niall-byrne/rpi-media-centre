#!/bin/bash

setup() {
  _mock.create _testing.error
  _mock.create invalid_parametrizer
  _mock.create @parametrize_with_valid_name
}

test_parametrize_components_validate_fn_name_parametrizer__non_existent_fn_name__generates_error_message() {
  @parametrize._components.validate.fn_name.parametrizer "non_existent_fn_name"

  _testing.error.mock.assert_calls_are \
    "1($(_testing.message.get PARAMETRIZE_ERROR_PARAMETRIZER_FN_INVALID "non_existent_fn_name"))" \
    "1($(_testing.message.get PARAMETRIZE_ERROR_FN_DOES_NOT_EXIST))"
}

test_parametrize_components_validate_fn_name_parametrizer__non_existent_fn_name__returns_status_code_126() {
  _capture.rc @parametrize._components.validate.fn_name.parametrizer "non_existent_fn_name"

  assert_rc "126"
}

test_parametrize_components_validate_fn_name_parametrizer__invalid_fn_name_______generates_error_message() {
  @parametrize._components.validate.fn_name.parametrizer "invalid_parametrizer"

  _testing.error.mock.assert_calls_are \
    "1($(_testing.message.get PARAMETRIZE_ERROR_PARAMETRIZER_FN_INVALID "invalid_parametrizer"))" \
    "1($(_testing.message.get PARAMETRIZE_ERROR_PARAMETRIZER_FN_NAME))"
}

test_parametrize_components_validate_fn_name_parametrizer__invalid_fn_name_______returns_status_code_126() {
  _capture.rc @parametrize._components.validate.fn_name.parametrizer "invalid_parametrizer"

  assert_rc "126"
}

test_parametrize_components_validate_fn_name_parametrizer__valid_fn_name_________does_not_generate_an_error() {
  @parametrize._components.validate.fn_name.parametrizer "@parametrize_with_valid_name"

  _testing.error.mock.assert_not_called
}
