#!/bin/bash

setup() {
  _mock.create _cli_log_error
  _mock.create command
}

@parametrize_with_dependency_found() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_COMMAND_CALL_RC;TEST_COMMAND_ARG_DEFINITION;EXPECTED_RC" \
    "command1;0;command1|my_dependency1|install_instructions1;0" \
    "command2;0;command2|my_dependency2|install_instructions2;0"
}

@parametrize_with_dependency_not_found() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_COMMAND_CALL_RC;TEST_COMMAND_ARG_DEFINITION;EXPECTED_RC" \
    "command1;1;command1|my_dependency1|install_instructions1;127" \
    "command2;1;command2|my_dependency2|install_instructions2;127"
}

test_dependencies_enforce__@vary__@vary__returns_expected_return_code() {
  local command_args=()

  command.mock.set.rc "${TEST_COMMAND_CALL_RC}"
  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARG_DEFINITION}"

  _capture.rc _dependencies_enforce "${command_args[@]}" > /dev/null

  assert_rc "${EXPECTED_RC}"
}

@parametrize.apply \
  test_dependencies_enforce__@vary__@vary__returns_expected_return_code \
  @parametrize_with_dependency_found \
  @parametrize_with_dependency_not_found

test_dependencies_enforce__dependency_found______@vary__does_not_log_error() {
  local command_args=()

  command.mock.set.rc "${TEST_COMMAND_CALL_RC}"
  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARG_DEFINITION}"

  _dependencies_enforce "${command_args[@]}" > /dev/null

  _cli_log_error.mock.assert_not_called
}

@parametrize_with_dependency_found \
  test_dependencies_enforce__dependency_found______@vary__does_not_log_error

test_dependencies_enforce__dependency_not_found__@vary__prints_error_message() {
  local command_args=()

  command.mock.set.rc "${TEST_COMMAND_CALL_RC}"
  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARG_DEFINITION}"

  _dependencies_enforce "${command_args[@]}" > /dev/null

  _cli_log_error.mock.assert_calls_are \
    "1(DEPENDENCIES: ${command_args[1]} is required by pictl, but it could not be found.)"
}

@parametrize_with_dependency_not_found \
  test_dependencies_enforce__dependency_not_found__@vary__prints_error_message

test_dependencies_enforce__dependency_not_found__@vary__prints_install_instructions() {
  local command_args=()

  command.mock.set.rc "${TEST_COMMAND_CALL_RC}"
  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARG_DEFINITION}"

  _capture.output _dependencies_enforce "${command_args[@]}"

  assert_output "${command_args[2]}"
}

@parametrize_with_dependency_not_found \
  test_dependencies_enforce__dependency_not_found__@vary__prints_install_instructions
