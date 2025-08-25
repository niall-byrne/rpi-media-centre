#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

_example_subtract_fn() {
  [[ "${#@}" == "2" ]] || return 127

  echo $(("${1}" - "${2}"))
}

_example_fn_with_no_args() {
  echo "fn that takes no args"
}

@parametrize_with_arg_combos() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;EXPECTED_RC" \
    "no_args_________________________127;;127" \
    "extra_arg_______________________127;_example_subtract_fn|target_name|-1|extra_arg;127" \
    "null_fn_name____________________126;|;126" \
    "null_optional_target_fn_name______0;_example_subtract_fn|;0" \
    "null_optional_arg_index___________0;_example_subtract_fn|||;0" \
    "fn_does_not_exist_______________126;non_existent|;126" \
    "invalid__target_fn_name_________126;_example_subtract_fn|invalid!target name;126" \
    "arg_index_is_not_a_number_______126;_example_subtract_fn|target_name|a;126" \
    "arg_index_is_zero_______________126;_example_subtract_fn|target_name|0;126" \
    "include_source_and_target_________0;_example_subtract_fn|target_name;0" \
    "include_source_index______________0;_example_subtract_fn||1;0" \
    "include_source_target_and_index___0;_example_subtract_fn|target_name|1;0"
}

@parametrize_with_input_output_arg_combos() {
  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_COMMAND_ARGS_DEFINITION;TEST_OUTPUT;TEST_EXPECTED_FINAL_OUTPUT" \
    "target_fn_with_args_____default_fn_name__default_position___;_example_subtract_fn;_example_subtract_fn_var|2|TEST_OUTPUT;3;-1" \
    "target_fn_with_args_____custom_name______default_position___;_example_subtract_fn|_custom_name;_custom_name|2|TEST_OUTPUT;3;-1" \
    "target_fn_with_args_____default_fn_name__specify_first______;_example_subtract_fn||1;_example_subtract_fn_var|TEST_OUTPUT|2;3;1" \
    "target_fn_with_args_____custom_name______specify_first______;_example_subtract_fn|_custom_name|1;_custom_name|TEST_OUTPUT|2;3;1" \
    "target_fn_with_args_____default_fn_name__specify_second_____;_example_subtract_fn||2;_example_subtract_fn_var|2|TEST_OUTPUT;3;-1" \
    "target_fn_with_args_____custom_name______specify_second_____;_example_subtract_fn|_custom_name|2;_custom_name|2|TEST_OUTPUT;3;-1" \
    "target_fn_with_args_____default_fn_name__specify_last_______;_example_subtract_fn||-1;_example_subtract_fn_var|2|TEST_OUTPUT;3;-1" \
    "target_fn_with_args_____custom_name______specify_last_______;_example_subtract_fn|_custom_name|-1;_custom_name|2|TEST_OUTPUT;3;-1" \
    "target_fn_with_args_____default_fn_name__specify_second_last;_example_subtract_fn||-2;_example_subtract_fn_var|TEST_OUTPUT|2;3;1" \
    "target_fn_with_args_____custom_name______specify_second_last;_example_subtract_fn|_custom_name|-2;_custom_name|TEST_OUTPUT|2;3;1" \
    "target_fn_without_args__default_fn_name__default_position___;_example_fn_with_no_args;_example_fn_with_no_args_var|TEST_OUTPUT;;fn that takes no args;" \
    "target_fn_without_args__custom_name______default_position___;_example_fn_with_no_args|_custom_name;_custom_name|TEST_OUTPUT;;fn that takes no args;" \
    "target_fn_without_args__default_fn_name__specify_first______;_example_fn_with_no_args||1;_example_fn_with_no_args_var|TEST_OUTPUT;;fn that takes no args;" \
    "target_fn_without_args__custom_name______specify_first______;_example_fn_with_no_args|_custom_name|1;_custom_name|TEST_OUTPUT;;fn that takes no args;" \
    "target_fn_without_args__default_fn_name__specify_last_______;_example_fn_with_no_args||-1;_example_fn_with_no_args_var|TEST_OUTPUT;;fn that takes no args;" \
    "target_fn_without_args__custom_name______specify_last_______;_example_fn_with_no_args|_custom_name|-1;_custom_name|TEST_OUTPUT;;fn that takes no args;"
}

test_stdlib_fn_derive_var__@vary_____________________returns_expected_status_code() {
  local args=()

  stdlib.array.make.from_string "args" "|" "${TEST_ARGS_DEFINITION}"

  # shellcheck disable=SC2154
  _capture.rc stdlib.fn.derive.var "${args[@]}"

  assert_rc "${EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_fn_derive_var__@vary_____________________returns_expected_status_code

# shellcheck disable=SC2034
test_stdlib_fn_derive_var__valid_args______________________@vary__derived_fn_works_stores_output_in_var() {
  local args=()
  local test_command_args=()

  stdlib.array.make.from_string "args" "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string "test_command_args" "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  stdlib.fn.derive.var "${args[@]}"

  "${test_command_args[@]}"

  assert_output "${TEST_EXPECTED_FINAL_OUTPUT}"
}

@parametrize_with_input_output_arg_combos \
  test_stdlib_fn_derive_var__valid_args______________________@vary__derived_fn_works_stores_output_in_var
