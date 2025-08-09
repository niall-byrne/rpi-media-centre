#!/bin/bash

setup() {
  _mock.create _testing.error
  _testing.error.mock.set.rc 127
}

test_parametrize_components_validate_fn_name_parametrizer__invalid_fn_name__generates_error_message() {
  @parametrize._components.validate.fn_name.parametrizer "invalid_name"

  _testing.error.mock.assert_called_once_with \
    "The function 'invalid_name' cannot be used in a parametrize series!  It's name must be prefixed with '${_PARAMETRIZE_MULTIPLE_PREFIX}' !"
}

test_parametrize_components_validate_fn_name_parametrizer__valid_fn_name__does_not_generate_an_error() {
  @parametrize._components.validate.fn_name.parametrizer "@parametrize_with_valid_name"

  _testing.error.mock.assert_not_called
}
