#!/bin/bash

setup() {
  _fixture_mock_logs
}

@parametrize_warning_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "NEW_VALUE;ORIGINAL_VALUE;RESPONSIBLE_ENTITY" \
    "mutated_variable;new_value;original_value;responsible_entity"
}

@parametrize_warning_bypass_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "NEW_VALUE;ORIGINAL_VALUE;RESPONSIBLE_ENTITY" \
    "stable_variable_;original_value;original_value;responsible_entity"
}

test_security_warning_variable_mutated__@vary__logs_warning_messages() {
  _security_warning_variable_mutated "NEW_VALUE" "ORIGINAL_VALUE" "RESPONSIBLE_ENTITY"

  _cli_log_warning.mock.assert_called_once_with \
    "SECURITY: The configured NEW_VALUE value has been overridden due to the value of RESPONSIBLE_ENTITY."
  _cli_log_info.mock.assert_called_once_with \
    "Please consider removing the unnecessary NEW_VALUE value."
}

@parametrize_warning_combos \
  test_security_warning_variable_mutated__@vary__logs_warning_messages

test_security_warning_variable_mutated__@vary__does_not_log_warning_messages() {
  _security_warning_variable_mutated "NEW_VALUE" "ORIGINAL_VALUE" "RESPONSIBLE_ENTITY"

  _cli_log_warning.mock.assert_not_called
  _cli_log_info.mock.assert_not_called
}

@parametrize_warning_bypass_combos \
  test_security_warning_variable_mutated__@vary__does_not_log_warning_messages
