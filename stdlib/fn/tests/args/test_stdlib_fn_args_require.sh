#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
  stdlib.logger.error.mock.set.keywords "_STDLIB_LOGGING_MESSAGE_PREFIX"
}

@parametrize_with_required_arg_returns_codes() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_REQUIRED;TEST_ARGS_OPTIONAL;TEST_ARGS_NULL_SAFE_DEFINITION;TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "0_required__0_optional_args__no_null____1_given__no_null_args__returns_status_code_127;0;0;;arg1;127;" \
    "0_required__0_optional_args__no_null____0_given__no_null_args__returns_status_code___0;0;0;;;0;" \
    "2_required__0_optional_args__no_null____2_given__no_null_args__returns_status_code___0;2;0;;arg1|arg2;0;" \
    "2_required__0_optional_args__no_null____2_given__2_null_arg____returns_status_code_126;2;0;;arg1||;126;" \
    "2_required__0_optional_args__no_null____3_given__no_null_args__returns_status_code_127;2;0;;arg1|arg2|arg3;127;" \
    "2_required__0_optional_args__1_null_ok__2_given__1_null_arg____returns_status_code___0;2;0;1;|arg2|;0;" \
    "2_required__0_optional_args__2_null_ok__2_given__2_null_arg____returns_status_code___0;2;0;2;arg1||;0;" \
    "2_required__0_optional_args__1_null_ok__2_given__all_null_arg__returns_status_code_126;2;0;1;||;126;" \
    "2_required__0_optional_args__1_null_ok__1_given__no_null_args__returns_status_code_127;2;0;1;arg1;127;"
}

@parametrize_with_optional_arg_return_codes() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_REQUIRED;TEST_ARGS_OPTIONAL;TEST_ARGS_NULL_SAFE_DEFINITION;TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "2_required__1_optional_args__no_null____2_given__no_null_args__returns_status_code___0;2;1;;arg1|arg2;0;" \
    "2_required__1_optional_args__no_null____2_given__1_null_arg____returns_status_code_127;2;1;;arg1|;127;" \
    "2_required__1_optional_args__3_null_ok__2_given__3_null_arg____returns_status_code___0;2;1;3;arg1|arg2||;0;" \
    "2_required__1_optional_args__no_null____3_given__no_null_args__returns_status_code___0;2;1;;arg1|arg2|arg3;0;" \
    "2_required__1_optional_args__no_null____3_given__1_null_arg____returns_status_code_126;2;1;;arg1|arg2||;126;"
}

@parametrize_with_error_logs() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_REQUIRED;TEST_ARGS_OPTIONAL;TEST_ARGS_NULL_SAFE_DEFINITION;TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITIONS" \
    "2_required__0_optional_args__no_null____1_given__no_null_args;2;0;;arg1;ARGUMENT_REQUIREMENTS_VIOLATION|2|0 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|1" \
    "2_required__0_optional_args__no_null____2_given__1_null_arg__;2;0;;|arg2;ARGUMENT_REQUIREMENTS_VIOLATION|2|0 ARGUMENT_REQUIREMENTS_VIOLATION_NULL|1" \
    "2_required__0_optional_args__1_null_ok__2_given__2_null_args;2;0;1;||;ARGUMENT_REQUIREMENTS_VIOLATION|2|0 ARGUMENT_REQUIREMENTS_VIOLATION_NULL|2"
}

test_stdlib_fn_args_require__@vary__@vary() {
  local _STDLIB_ARGS_NULL_SAFE=()
  local args=()

  IFS="|" read -ra args <<< "${TEST_ARGS_DEFINITION}"
  IFS="|" read -ra _STDLIB_ARGS_NULL_SAFE <<< "${TEST_ARGS_NULL_SAFE_DEFINITION}"

  _capture.rc stdlib.fn.args.require "${TEST_ARGS_REQUIRED}" "${TEST_ARGS_OPTIONAL}" "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize.apply \
  test_stdlib_fn_args_require__@vary__@vary \
  @parametrize_with_required_arg_returns_codes \
  @parametrize_with_optional_arg_return_codes

test_stdlib_fn_args_require__@vary__default_function_name_____generates_correct_error_logs() {
  local _STDLIB_ARGS_NULL_SAFE=()
  local _STDLIB_ARGS_CALLER_FN_NAME=""
  local args=()
  local message_arg_definition
  local message_arg_definitions=()
  local message_args=()

  IFS="|" read -ra args <<< "${TEST_ARGS_DEFINITION}"
  IFS="|" read -ra _STDLIB_ARGS_NULL_SAFE <<< "${TEST_ARGS_NULL_SAFE_DEFINITION}"
  IFS=" " read -ra message_arg_definitions <<< "${TEST_MESSAGE_ARG_DEFINITIONS}"
  for message_arg_definition in "${message_arg_definitions[@]}"; do
    IFS="|" read -ra message_args <<< "${message_arg_definition}"
    expected_log_messages+=("1($(stdlib.message.get "${message_args[@]}")) _STDLIB_LOGGING_MESSAGE_PREFIX(${FUNCNAME[0]})")
  done

  stdlib.fn.args.require "${TEST_ARGS_REQUIRED}" "${TEST_ARGS_OPTIONAL}" "${args[@]}"

  stdlib.logger.error.mock.assert_calls_are \
    "${expected_log_messages[@]}"
}

@parametrize_with_error_logs \
  test_stdlib_fn_args_require__@vary__default_function_name_____generates_correct_error_logs

test_stdlib_fn_args_require__@vary__overridden_function_name__generates_correct_error_logs() {
  local _STDLIB_ARGS_NULL_SAFE=()
  local _STDLIB_ARGS_CALLER_FN_NAME="override logging message prefix"
  local args=()
  local message_arg_definition
  local message_arg_definitions=()
  local message_args=()

  IFS="|" read -ra args <<< "${TEST_ARGS_DEFINITION}"
  IFS="|" read -ra _STDLIB_ARGS_NULL_SAFE <<< "${TEST_ARGS_NULL_SAFE_DEFINITION}"
  IFS=" " read -ra message_arg_definitions <<< "${TEST_MESSAGE_ARG_DEFINITIONS}"
  for message_arg_definition in "${message_arg_definitions[@]}"; do
    IFS="|" read -ra message_args <<< "${message_arg_definition}"
    expected_log_messages+=("1($(stdlib.message.get "${message_args[@]}")) _STDLIB_LOGGING_MESSAGE_PREFIX(override logging message prefix)")
  done

  stdlib.fn.args.require "${TEST_ARGS_REQUIRED}" "${TEST_ARGS_OPTIONAL}" "${args[@]}"

  stdlib.logger.error.mock.assert_calls_are \
    "${expected_log_messages[@]}"
}

@parametrize_with_error_logs \
  test_stdlib_fn_args_require__@vary__overridden_function_name__generates_correct_error_logs
