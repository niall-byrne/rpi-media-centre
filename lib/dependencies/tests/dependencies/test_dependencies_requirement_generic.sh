#!/bin/bash

setup() {
  _mock.create _dependencies_enforce
}

@parametrize_with_generic_options() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_COMMAND" \
    "command1;command1" \
    "command2;command2"
}

test_dependencies_requirement_generic__@vary__enforce_is_called_with_correct_arguments() {
  _dependencies_requirement_generic "${TEST_COMMAND}"

  _dependencies_enforce.mock.assert_calls_are \
    "1(${TEST_COMMAND}) 2(The application ${TEST_COMMAND}) 3(Please consider running: sudo apt-get install ${TEST_COMMAND})"
}

@parametrize_with_generic_options \
  test_dependencies_requirement_generic__@vary__enforce_is_called_with_correct_arguments
