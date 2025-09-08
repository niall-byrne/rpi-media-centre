#!/bin/bash

setup() {
  _mock.create _backup_cli_usage_error
  _mock.create _filesystem_resolve_path_relative_to_cli
  _mock.create _backup_manifest_all_command
}

@parametrize_with_missing_args() {
  # $1: the test to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARG_DEFINITION" \
    "no_job_name__path_name___;|/path/to/recover" \
    "job1_________no_path_name;job1|" \
    "no_job_name__no_path_name;;"
}

@parametrize_with_args() {
  # $1: the test to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARG_DEFINITION" \
    "job1_________path_name___;job1|/path/to/recover1" \
    "job2_________path_name___;job2|/path/to/recover2"
}

test_backup_cli_recover__@vary__calls_usage_error() {
  local command_args

  stdlib.array.make.from_string command_args "|" "${TEST_ARG_DEFINITION}"

  _backup_cli_recover "${command_args[@]}"

  _backup_cli_usage_error.mock.assert_called_once_with ""
}

@parametrize_with_missing_args \
  test_backup_cli_recover__@vary__calls_usage_error

test_backup_cli_recover__@vary__resolves_path() {
  local command_args

  stdlib.array.make.from_string command_args "|" "${TEST_ARG_DEFINITION}"

  _backup_cli_recover "${command_args[@]}"

  _filesystem_resolve_path_relative_to_cli.mock.assert_called_once_with \
    "1(${command_args[1]})"
}

@parametrize_with_args \
  test_backup_cli_recover__@vary__resolves_path

test_backup_cli_recover__@vary__calls_manifest_command() {
  local command_args

  stdlib.array.make.from_string command_args "|" "${TEST_ARG_DEFINITION}"

  _backup_cli_recover "${command_args[@]}"

  _backup_manifest_all_command.mock.assert_called_once_with \
    "1(_backup_job_task_recover) 2() 3(${command_args[0]})"
}

@parametrize_with_args \
  test_backup_cli_recover__@vary__calls_manifest_command
