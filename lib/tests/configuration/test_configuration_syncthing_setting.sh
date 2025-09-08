#!/bin/bash

setup() {
  _mock.create _cli_log_warning
  _mock.create curl
  _mock.create _docker_compose_exec
  _mock.create sleep

  curl.mock.set.rc 0
}

_curl_side_effect() {
  TEST_CURL_CALL_COUNT="$((TEST_CURL_CALL_COUNT + 1))"

  if [[ "${TEST_CURL_CALL_COUNT}" -lt 3 ]]; then
    return 1
  fi
  return 0
}

@parametrize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_COMMAND_ARGS_DEFINITION;TEST_VALUE" \
    "username;RPI_SYNCTHING_CREDENTIALS_USERNAME|gui|user;username1" \
    "password;RPI_SYNCTHING_CREDENTIALS_PASSWORD|gui|password;secret1"
}

test_configuration_syncthing_setting__env_var_not_set__@vary__does_not_log_warning_message() {
  local command_args

  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"
  local "${command_args[0]}"
  printf -v "${command_args[0]}" "%s" ""

  _configuration_syncthing_setting "${command_args[@]}"

  _cli_log_warning.mock.assert_not_called
}

@parametrize_with_arg_combos \
  test_configuration_syncthing_setting__env_var_not_set__@vary__does_not_log_warning_message

test_configuration_syncthing_setting__env_var_set______@vary__logs_warning_message() {
  local command_args

  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"
  local "${command_args[0]}"
  printf -v "${command_args[0]}" "%s" "${TEST_VALUE}"

  _configuration_syncthing_setting "${command_args[@]}"

  _cli_log_warning.mock.assert_called_once_with \
    "1(Configuring syncthing '${command_args[1]} ${command_args[2]}' with environment variable '${command_args[0]}' ...)"
}

@parametrize_with_arg_combos \
  test_configuration_syncthing_setting__env_var_set______@vary__logs_warning_message

test_configuration_syncthing_setting__env_var_not_set__@vary__does_not_call_curl() {
  local command_args

  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"
  local "${command_args[0]}"
  printf -v "${command_args[0]}" "%s" ""

  _configuration_syncthing_setting "${command_args[@]}"

  curl.mock.assert_not_called
}

@parametrize_with_arg_combos \
  test_configuration_syncthing_setting__env_var_not_set__@vary__does_not_call_curl

test_configuration_syncthing_setting__env_var_set______@vary__calls_curl() {
  local command_args

  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"
  local "${command_args[0]}"
  printf -v "${command_args[0]}" "%s" "${TEST_VALUE}"

  _configuration_syncthing_setting "${command_args[@]}"

  curl.mock.assert_called_once_with \
    "1(-fkLsS) 2(-m) 3(2) 4(127.0.0.1:8384/rest/noauth/health)"
}

@parametrize_with_arg_combos \
  test_configuration_syncthing_setting__env_var_set______@vary__calls_curl

test_configuration_syncthing_setting__env_var_set______@vary__calls_curl_until_success() {
  local TEST_CURL_CALL_COUNT=0
  local command_args

  curl.mock.set.subcommand _curl_side_effect
  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"
  local "${command_args[0]}"
  printf -v "${command_args[0]}" "%s" "${TEST_VALUE}"

  _configuration_syncthing_setting "${command_args[@]}"

  curl.mock.assert_count_is 3
}

@parametrize_with_arg_combos \
  test_configuration_syncthing_setting__env_var_set______@vary__calls_curl_until_success

test_configuration_syncthing_setting__env_var_set______@vary__sleeps_between_curl_calls() {
  local TEST_CURL_CALL_COUNT=0
  local command_args

  curl.mock.set.subcommand _curl_side_effect
  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"
  local "${command_args[0]}"
  printf -v "${command_args[0]}" "%s" "${TEST_VALUE}"

  _configuration_syncthing_setting "${command_args[@]}"

  sleep.mock.assert_calls_are \
    "1(1)" \
    "1(1)" \
    "1(1)"
}

@parametrize_with_arg_combos \
  test_configuration_syncthing_setting__env_var_set______@vary__sleeps_between_curl_calls

test_configuration_syncthing_setting__env_var_not_set__@vary__does_not_call_docker_compose_exec() {
  local command_args

  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"
  local "${command_args[0]}"
  printf -v "${command_args[0]}" "%s" ""

  _configuration_syncthing_setting "${command_args[@]}"

  _docker_compose_exec.mock.assert_not_called
}

@parametrize_with_arg_combos \
  test_configuration_syncthing_setting__env_var_not_set__@vary__does_not_call_docker_compose_exec

test_configuration_syncthing_setting__env_var_set______@vary__calls_docker_compose_exec_to_configure_syncthing() {
  local RPI_SYNCTHING_CREDENTIALS_USERNAME="${TEST_VALUE}"
  local command_args

  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"
  local "${command_args[0]}"
  printf -v "${command_args[0]}" "%s" "${TEST_VALUE}"

  _configuration_syncthing_setting "${command_args[@]}"

  _docker_compose_exec.mock.assert_called_once_with \
    "1(syncthing) 2(syncthing) 3(cli) 4(config) 5(${command_args[1]}) 6(${command_args[2]}) 7(set) 8(${RPI_SYNCTHING_CREDENTIALS_USERNAME})"
}

@parametrize_with_arg_combos \
  test_configuration_syncthing_setting__env_var_set______@vary__calls_docker_compose_exec_to_configure_syncthing
