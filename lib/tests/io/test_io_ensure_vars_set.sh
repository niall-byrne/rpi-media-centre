#!/bin/bash

setup() {
  _fixture_mock_logs
  local TEST_ARGUMENTS=()
}

@parametrize_incorrect_arg_count_combos() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGUMENT_DEFINITION" \
    "1_variable_,TEST_VAR2" \
    "2_variables,TEST_VAR1|TEST_VAR2"
}

@parametrize_correct_arg_count__unset_variable__combos() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGUMENT_DEFINITION,TEST_UNSET_INDEX" \
    "1_variable_unset_,TEST_VAR1||TEST_VAR2,2" \
    "2_variables_unset,TEST_VAR1|TEST_VAR2||||TEST_VAR3,3"
}

test_io_ensure_vars_set__@vary__incorrect_count__logs_error_message() {
  _array_from_string TEST_ARGUMENTS "|" "${TEST_ARGUMENT_DEFINITION}"

  _io_ensure_vars_set "3" "${TEST_ARGUMENTS[@]}"

  _cli_log_error.mock.assert_called_once_with \
    "Expected '3' arguments, but received '${#TEST_ARGUMENTS[@]}'!"
}

@parametrize_incorrect_arg_count_combos \
  test_io_ensure_vars_set__@vary__incorrect_count__logs_error_message

test_io_ensure_vars_set__@vary__incorrect_count__returns_127() {
  _array_from_string TEST_ARGUMENTS "|" "${TEST_ARGUMENT_DEFINITION}"

  _capture.rc _io_ensure_vars_set "3" "${TEST_ARGUMENTS[@]}"

  assert_rc "127"
}

@parametrize_incorrect_arg_count_combos \
  test_io_ensure_vars_set__@vary__incorrect_count__returns_127

test_io_ensure_vars_set__@vary__correct_count__variables_set____returns_0() {
  _array_from_string TEST_ARGUMENTS "|" "${TEST_ARGUMENT_DEFINITION}"

  _capture.rc _io_ensure_vars_set "${#TEST_ARGUMENTS[@]}" "${TEST_ARGUMENTS[@]}"

  assert_rc "0"
}

@parametrize \
  "test_io_ensure_vars_set__@vary__correct_count__variables_set____returns_0" \
  "TEST_ARGUMENT_DEFINITION" \
  "1_variable____,TEST_VAR2" \
  "3_variables___,TEST_VAR1|TEST_VAR2|TEST_VAR3"

test_io_ensure_vars_set__@vary__correct_count__variables_unset__logs_error_message() {
  _array_from_string TEST_ARGUMENTS "|" "${TEST_ARGUMENT_DEFINITION}"

  _io_ensure_vars_set "${#TEST_ARGUMENTS[@]}" "${TEST_ARGUMENTS[@]}"

  _cli_log_error.mock.assert_called_once_with \
    "Expected '${#TEST_ARGUMENTS[@]}' arguments, but argument '${TEST_UNSET_INDEX}' was unset!"
}

@parametrize_correct_arg_count__unset_variable__combos \
  test_io_ensure_vars_set__@vary__correct_count__variables_unset__logs_error_message

test_io_ensure_vars_set__@vary__correct_count__variables_unset__returns_127() {
  _array_from_string TEST_ARGUMENTS "|" "${TEST_ARGUMENT_DEFINITION}"

  _capture.rc _io_ensure_vars_set "${#TEST_ARGUMENTS[@]}" "${TEST_ARGUMENTS[@]}"

  assert_rc "127"
}

@parametrize_correct_arg_count__unset_variable__combos \
  test_io_ensure_vars_set__@vary__correct_count__variables_unset__returns_127
