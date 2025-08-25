#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

_example_add_fn() {
  echo $(("${1}" + "${2}"))
}

@parametrize_with_arg_combos() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args______________________127;;127" \
    "extra_arg____________________127;_example_add_fn|_example_add_fn_reference|extra_arg;127" \
    "null_fn_name_________________126;|_example_add_fn_reference;126" \
    "null_fn_reference____________126;_example_add_fn||;126" \
    "fn_name_does_not_exist_______126;non_existent|_example_add_fn_reference;126" \
    "invalid_fn_reference_________126;_example_add_fn|invalid function#name;126" \
    "valid_fn_name_and_reference__0__;_example_add_fn|_example_add_fn_reference;0"
}

test_stdlib_fn_derive_clone__invalid_args__@vary__returns_expected_status_code() {
  stdlib.array.make.from_string "args" "|" "${TEST_ARGS_DEFINITION}"

  # shellcheck disable=SC2154
  _capture.rc stdlib.fn.derive.clone "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_fn_derive_clone__invalid_args__@vary__returns_expected_status_code

test_stdlib_fn_derive_clone__valid_args____maintains_old_function() {
  stdlib.fn.derive.clone "_example_add_fn" "_example_add_fn_reference"

  _capture.output _example_add_fn "2" "3"

  assert_output "5"
  stdlib.fn.assert.is_fn _example_add_fn
}

test_stdlib_fn_derive_clone__valid_args____creates_new_function_with_reference() {
  stdlib.fn.derive.clone "_example_add_fn" "_example_add_fn_reference"

  _capture.output _example_add_fn_reference "2" "3"

  assert_output "5"
  stdlib.fn.assert.is_fn _example_add_fn_reference
}
