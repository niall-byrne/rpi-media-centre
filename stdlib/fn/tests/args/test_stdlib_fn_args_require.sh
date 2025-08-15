#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
  #echo
}

@parametrize_with_required_arg_returns_codes() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "ARGS_REQUIRED,ARGS_OPTIONAL,ARGS_NULL_SAFE_DEFINITION,ARGS_DEFINITION,EXPECTED_RC" \
    "2_required__0_optional_args__no_null____2_given__no_null_args__returns_status_code_0,2,0,0,arg1|arg2,0," \
    "2_required__0_optional_args__no_null____2_given__2_null_arg____returns_status_code_126,2,0,0,arg1||,126," \
    "2_required__0_optional_args__no_null____3_given__no_null_args__returns_status_code_127,2,0,0,arg1|arg2|arg3,127," \
    "2_required__0_optional_args__1_null_ok__2_given__1_null_arg____returns_status_code_0,2,0,1,|arg2|,0," \
    "2_required__0_optional_args__2_null_ok__2_given__2_null_arg____returns_status_code_0,2,0,2,arg1||,0," \
    "2_required__0_optional_args__1_null_ok__2_given__all_null_arg__returns_status_code_126,2,0,1,||,126," \
    "2_required__0_optional_args__1_null_ok__1_given__no_null_args__returns_status_code_127,2,0,1,arg1,127,"
}

@parametrize_with_optional_arg_return_codes() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "ARGS_REQUIRED,ARGS_OPTIONAL,ARGS_NULL_SAFE_DEFINITION,ARGS_DEFINITION,EXPECTED_RC" \
    "2_required__1_optional_args__no_null____2_given__no_null_args__returns_status_code_0,2,1,0,arg1|arg2,0," \
    "2_required__1_optional_args__no_null____2_given__1_null_arg____returns_status_code_127,2,1,0,arg1|,127," \
    "2_required__1_optional_args__3_null_ok__2_given__3_null_arg____returns_status_code_0,2,1,3,arg1|arg2||,0," \
    "2_required__1_optional_args__no_null____3_given__no_null_args__returns_status_code_0,2,1,0,arg1|arg2|arg3,0," \
    "2_required__1_optional_args__no_null____3_given__1_null_arg____returns_status_code_126,2,1,0,arg1|arg2||,126,"
}

test_stdlib_fn_args_require__@vary__@vary() {
  local args=()
  local _ARGS_NULL_SAFE=()

  IFS="|" read -ra args <<< "${ARGS_DEFINITION}"
  IFS="|" read -ra _ARGS_NULL_SAFE <<< "${ARGS_NULL_SAFE_DEFINITION}"

  _capture.rc stdlib.fn.args.require "${ARGS_REQUIRED}" "${ARGS_OPTIONAL}" "${args[@]}"

  assert_rc "${EXPECTED_RC}"
}

@parametrize.apply \
  test_stdlib_fn_args_require__@vary__@vary \
  @parametrize_with_required_arg_returns_codes \
  @parametrize_with_optional_arg_return_codes

test_stdlib_fn_args_require__@vary__generates_correct_error_logs() {
  local args=()
  local _ARGS_NULL_SAFE=()

  IFS="|" read -ra args <<< "${ARGS_DEFINITION}"
  IFS="|" read -ra _ARGS_NULL_SAFE <<< "${ARGS_NULL_SAFE_DEFINITION}"

  stdlib.fn.args.require "${ARGS_REQUIRED}" "${ARGS_OPTIONAL}" "${args[@]}"

  stdlib.logger.error.mock.assert_count_is "2"
  stdlib.logger.error.mock.assert_call_n_is "1" "${FUNCNAME[0]}: ${EXPECTED_ERROR_1}"
  stdlib.logger.error.mock.assert_call_n_is "2" "${FUNCNAME[0]}: ${EXPECTED_ERROR_2}"
}

@parametrize \
  test_stdlib_fn_args_require__@vary__generates_correct_error_logs \
  "ARGS_REQUIRED,ARGS_OPTIONAL,_ARGS_NULL_SAFE,ARGS_DEFINITION,EXPECTED_ERROR_1,EXPECTED_ERROR_2" \
  "2_required__0_optional_args__no_null____2_given__1_null_arg__,2,0,0,arg1||,Expected '2' required argument(s) and '0' optional argument(s).,Argument '2' was null and is not null safe!," \
  "2_required__0_optional_args__1_null_ok__1_given__2_null_args,2,0,1,arg1,Expected '2' required argument(s) and '0' optional argument(s).,Received '1' argument(s)!," \
  "2_required__1_optional_args__no_null____2_given__1_null_arg_,2,1,0,arg1|,Expected '2' required argument(s) and '1' optional argument(s).,Received '1' argument(s)!" \
  "2_required__1_optional_args__no_null____3_given__3_null_arg_,2,1,0,arg1|arg2||,Expected '2' required argument(s) and '1' optional argument(s).,Argument '3' was null and is not null safe!"
