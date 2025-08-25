#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

_example_subtract_fn() {
  echo $(("${1}" - "${2}"))
}

# shellcheck disable=SC2120
_example_multiline_fn() {
  echo "Received: $1"
}

_example_fn_with_no_args() {
  echo "fn that takes no args"
}

@parametrize_with_arg_combos() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_________________________127;;127" \
    "extra_arg_______________________127;_example_subtract_fn|3|extra_arg;127" \
    "null_fn_name____________________126;|3;126" \
    "null_arg_count__________________126;_example_subtract_fn||;126" \
    "fn_name_does_not_exist__________126;non_existent|1;126" \
    "arg_count_is_not_digit__________126;_example_subtract_fn|aa;126" \
    "valid_fn_name_and_arg_count_____0__;_example_subtract_fn|3;0"
}

test_stdlib_fn_derive_pipeable__invalid_args__@vary__returns_expected_status_code() {
  stdlib.array.make.from_string "args" "|" "${TEST_ARGS_DEFINITION}"

  # shellcheck disable=SC2154
  _capture.rc stdlib.fn.derive.pipeable "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_fn_derive_pipeable__invalid_args__@vary__returns_expected_status_code

test_stdlib_fn_derive_pipeable__valid_args____example_fn_with_args____________handles_normal_input_as_expected() {
  stdlib.fn.derive.pipeable "_example_subtract_fn" "2"

  TEST_OUTPUT="$(_example_subtract_fn_pipe "2" "3")"

  assert_output "-1"
}

test_stdlib_fn_derive_pipeable__valid_args____example_fn_with_args____________default_arg_position__handles_piped_input_as_expected() {
  stdlib.fn.derive.pipeable "_example_subtract_fn" "2"

  TEST_OUTPUT="$(echo "3" | _example_subtract_fn_pipe "2")"

  assert_output "-1"
}

test_stdlib_fn_derive_pipeable__valid_args____example_fn_with_args____________stdin_placeholder_arg_position_1__default_placeholder____handles_piped_input_as_expected() {
  stdlib.fn.derive.pipeable "_example_subtract_fn" "2"

  TEST_OUTPUT="$(echo "3" | _example_subtract_fn_pipe - "2")"

  assert_output "1"
}

test_stdlib_fn_derive_pipeable__valid_args____example_fn_with_args____________stdin_placeholder_arg_position_1__specified_placeholder__handles_piped_input_as_expected() {
  STDIN_SOURCE_SPECIFIER='*' stdlib.fn.derive.pipeable "_example_subtract_fn" "2"

  TEST_OUTPUT="$(echo "3" | _example_subtract_fn_pipe '*' "2")"

  assert_output "1"
}

test_stdlib_fn_derive_pipeable__valid_args____example_fn_with_args____________stdin_placeholder_arg_position_2__default_placeholder____handles_piped_input_as_expected() {
  stdlib.fn.derive.pipeable "_example_subtract_fn" "2"

  TEST_OUTPUT="$(echo "4" | _example_subtract_fn_pipe "2" -)"

  assert_output "-2"
}

test_stdlib_fn_derive_pipeable__valid_args____example_fn_with_args____________stdin_placeholder_arg_position_2__specified_placeholder__handles_piped_input_as_expected() {
  STDIN_SOURCE_SPECIFIER='*' stdlib.fn.derive.pipeable "_example_subtract_fn" "2"

  TEST_OUTPUT="$(echo "4" | _example_subtract_fn_pipe "2" '*')"

  assert_output "-2"
}

test_stdlib_fn_derive_pipeable__valid_args____example_multiline_fn_with_args__handles_normal_input_as_expected() {
  stdlib.fn.derive.pipeable "_example_multiline_fn" "1"

  TEST_OUTPUT="$(_example_multiline_fn_pipe "line 1"$'\n'"line 2"$'\n')"

  assert_output "Received: line 1"$'\n'"line 2"
}

test_stdlib_fn_derive_pipeable__valid_args____example_multiline_fn_with_args__multiline_input__handles_piped_input_as_expected() {
  stdlib.fn.derive.pipeable "_example_multiline_fn" "1"

  # shellcheck disable=SC2034
  TEST_OUTPUT="$({
    echo "line 1"
    echo "line 2"
  } | _example_multiline_fn_pipe)"

  assert_output "Received: line 1"$'\n'"line 2"
}
