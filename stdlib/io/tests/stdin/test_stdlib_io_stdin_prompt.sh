#!/bin/bash

#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_args_and_status_codes() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION,TEST_EXPECTED_RC" \
    "no_args_______________________________returns_status_code_127,,127" \
    "extra_arg_____________________________returns_status_code_127,input_var|Enter a value:|password|extra_arg,127" \
    "null_variable_name____________________returns_status_code_126,|Enter a value:|,126" \
    "null_prompt___________________________returns_status_code___0,input_var|,0" \
    "prompt_and_variable_name______________returns_status_code___0,input_var|Enter a value:,0" \
    "prompt_and_variable_name_as_password__returns_status_code___0,input_var|Enter a value:|password,0"
}

@parametrize_with_args_and_read_flags() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION,TEST_READ_ARGS" \
    "variable_name_______________________,input_var,-rp Enter a value:  input_var" \
    "prompt_and_variable_name____________,input_var|Enter a custom value:,-rp Enter a custom value: input_var" \
    "prompt_and_variable_name_as_password,input_var|Enter a custom value:|password,-rsp Enter a custom value: input_var"
}

test_stdlib_io_stdin_prompt__@vary() {
  local args=()

  IFS="|" read -ra args <<< "${TEST_ARGS_DEFINITION}"

  stdlib.io.stdin.prompt "${args[@]}" <<< "mocked stdin" > /dev/null

  assert_equals "${TEST_EXPECTED_RC}" "$?"
}

@parametrize_with_args_and_status_codes \
  test_stdlib_io_stdin_prompt__@vary

test_stdlib_io_stdin_prompt__@vary__calls_read_as_expected() {
  local args=()
  local expected_read_args=()

  IFS="|" read -ra args <<< "${TEST_ARGS_DEFINITION}"
  IFS="|" read -ra expected_read_args <<< "${TEST_READ_ARGS}"
  _mock.create read
  read.mock.set.subcommand "input_var='value'"

  stdlib.io.stdin.prompt "${args[@]}" > /dev/null

  unset -f read
  read.mock.assert_called_once_with "${expected_read_args[*]}"
}

@parametrize_with_args_and_read_flags \
  test_stdlib_io_stdin_prompt__@vary__calls_read_as_expected

test_stdlib_io_stdin_prompt__@vary__stores_the_stdin() {
  local args=()
  local input_var

  IFS="|" read -ra args <<< "${TEST_ARGS_DEFINITION}"

  stdlib.io.stdin.prompt "${args[@]}" <<< "mocked stdin" > /dev/null

  # shellcheck disable=SC2154
  assert_equals "mocked stdin" "${input_var}"
}

@parametrize_with_args_and_read_flags \
  test_stdlib_io_stdin_prompt__@vary__stores_the_stdin
