#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

_example_add_fn() {
  [[ "${#@}" == "2" ]] || return 127

  echo $(("${1}" + "${2}"))
}

_example_fn_with_no_args() {
  echo "fn that takes no args"
}

@parametrize_with_arg_combos() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION,EXPECTED_RC" \
    "no_args_________________________127,,127" \
    "extra_arg_______________________127,_example_add_fn|target_name|-1|extra_arg,127" \
    "null_source_fn_name_____________126,|,126" \
    "null_optional_target_fn_name______0,_example_add_fn|,0" \
    "null_optional_arg_index___________0,_example_add_fn|||,0" \
    "source_fn_does_not_exist________126,non_existent|,126" \
    "arg_index_is_not_a_number_______126,_example_add_fn|target_name|a,126" \
    "include_source_and_target_________0,_example_add_fn|target_name,0" \
    "include_source_index______________0,_example_add_fn||1,0" \
    "include_source_target_and_index___0,_example_add_fn|target_name|1,0"
}

test_stdlib_fn_derive_var__@vary_____________________returns_expected_status_code() {
  stdlib.array.make.from_string "args" "|" "${TEST_ARGS_DEFINITION}"

  # shellcheck disable=SC2154
  _capture.rc stdlib.fn.derive.var "${args[@]}"

  assert_rc "${EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_fn_derive_var__@vary_____________________returns_expected_status_code

# shellcheck disable=SC2034
test_stdlib_fn_derive_var__valid_args______________________target_fn_with_args_____default_fn_name__default_position__derived_fn_works_stores_output_in_var() {
  stdlib.fn.derive.var _example_add_fn
  TEST_OUTPUT="3"

  _example_add_fn_var 2 TEST_OUTPUT

  assert_output "5"
}

# shellcheck disable=SC2034
test_stdlib_fn_derive_var__valid_args______________________target_fn_with_args_____default_fn_name__specify_position__derived_fn_works_stores_output_in_var() {
  stdlib.fn.derive.var _example_add_fn "" "1"
  TEST_OUTPUT="3"

  _example_add_fn_var TEST_OUTPUT 2

  assert_output "5"
}

# shellcheck disable=SC2034
test_stdlib_fn_derive_var__valid_args______________________target_fn_with_args_____custom_name______default_position__derived_fn_works_stores_output_in_var() {
  stdlib.fn.derive.var _example_add_fn _custom_fn_name
  TEST_OUTPUT="3"

  _custom_fn_name 2 TEST_OUTPUT

  assert_output "5"
}

test_stdlib_fn_derive_var__valid_args______________________target_fn_without_args__default_fn_name__default_position__derived_fn_works_stores_output_in_var() {
  stdlib.fn.derive.var _example_fn_with_no_args

  _example_fn_with_no_args_var TEST_OUTPUT

  assert_output "fn that takes no args"
}

test_stdlib_fn_derive_var__valid_args______________________target_fn_without_args__custom_name______default_position__derived_fn_works_stores_output_in_var() {
  stdlib.fn.derive.var _example_fn_with_no_args _custom_fn_name

  _custom_fn_name TEST_OUTPUT

  assert_output "fn that takes no args"
}
