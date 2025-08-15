#!/bin/bash

setup() {
  _fixture_mock_logs
  _mock.create stdlib.fn.args.require
}

@parametrize_with_valid_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_OPTIONAL;TEST_REQUIRED" \
    "optional_unset__required_unset;;;" \
    "optional_unset__required_set__;;required_varname" \
    "optional_set____required_set__;optional_varname;required_varname;"

}

test_security_validate_ids_relationship__@vary__calls_stdlib_fn_args_require() {
  stdlib.array.make.from_string TEST_ARGUMENTS "|" "${TEST_ARGUMENT_DEFINITION}"
  stdlib.fn.args.require.mock.clear

  _security_validate_ids_relationship "${TEST_ARGUMENTS[@]}"

  stdlib.fn.args.require.mock.assert_called_once_with "3 0 ${EXPECTED_ARGS}"
}

@parametrize \
  test_security_validate_ids_relationship__@vary__calls_stdlib_fn_args_require \
  "TEST_ARGUMENT_DEFINITION;EXPECTED_ARGS" \
  "valid_arguments_;optional_varname|required_varname|entity_name;optional_varname required_varname entity_name" \
  "omitted_required;optional_varname||entity_name;optional_varname  entity_name" \
  "omitted_entity__;optional_varname|required_varname||;optional_varname required_varname "

# shellcheck disable=SC2034
test_security_validate_ids_relationship__valid_arguments___optional_set____required_unset__logs_error_message() {
  local TEST_OPTIONAL="optional"
  local TEST_REQUIRED=""
  local TEST_ENTITY="entity"

  _security_validate_ids_relationship "TEST_OPTIONAL" "TEST_REQUIRED" "TEST_ENTITY"

  _cli_log_error.mock.assert_count_is "2"
  _cli_log_error.mock.assert_call_n_is "1" \
    "SECURITY: invalid configuration!"
  _cli_log_error.mock.assert_call_n_is "2" \
    "The config cannot specify TEST_OPTIONAL without a value for TEST_REQUIRED:"
  _cli_log_info.mock.assert_count_is "2"
  _cli_log_info.mock.assert_call_n_is "1" \
    " - TEST_OPTIONAL may be used with the 'account' command to provision a new TEST_ENTITY"
  _cli_log_info.mock.assert_call_n_is "2" \
    " - TEST_REQUIRED may be used to specify an existing TEST_ENTITY"
}

# shellcheck disable=SC2034
test_security_validate_ids_relationship__valid_arguments___optional_unset__required_unset__returns_status_code_127() {
  local TEST_OPTIONAL=""
  local TEST_REQUIRED=""
  local TEST_ENTITY="entity"

  _capture.rc _security_validate_ids_relationship "TEST_OPTIONAL" "TEST_REQUIRED" "TEST_ENTITY"
  assert_rc "0"
}

# shellcheck disable=SC2034
test_security_validate_ids_relationship__valid_arguments___@vary__returns_status_code_0() {
  local TEST_ENTITY="entity"

  _capture.rc _security_validate_ids_relationship "TEST_OPTIONAL" "TEST_REQUIRED" "TEST_ENTITY"

  assert_rc "0"
}

@parametrize_with_valid_combos \
  test_security_validate_ids_relationship__valid_arguments___@vary__returns_status_code_0
