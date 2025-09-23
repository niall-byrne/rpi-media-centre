#!/bin/bash

setup() {
  _mock.create _cli_log_info
  _mock.create _backup_job_usage
  _mock.create _backup_job_validation
  _mock.create _backup_job_validation_queue
}

@parametrize_with_success_args() {
  # $1: the test to parametrize

  @parametrize \
    "${1}" \
    "@fixture _fixture_environment_variable_positions" \
    "TEST_ARGS_DEFINITION" \
    "all_specified_perms;-b|/path_tarball:0700|-k|/path_encryption_key|-n|job_name|-p|remote_parameter|-q|queue_name|-r|/path_rsync:750|-s|/path_source|-t|remote_target://path|-v|version_count" \
    "missing_tarball____;-k|/path_encryption_key|-n|job_name|-p|remote_parameter|-q|queue_name|-r|/path_rsync:0750|-s|/path_source|-t|remote_target://path|-v|version_count" \
    "missing_encryption_;-n|job_name|-p|remote_parameter|-q|queue_name|-r|/path_rsync:0700|-s|/path_source|-t|remote_target://path|-v|version_count" \
    "no_args____________;;"
}

@parametrize_with_failure_args() {
  # $1: the test to parametrize

  local TEST_VARIABLE_PAIRS=()

  @parametrize \
    "${1}" \
    "@fixture _fixture_environment_variable_positions" \
    "TEST_ARGS_DEFINITION" \
    "invalid_arguments;-k|/path_encryption_key|-x|ddd|-b;"
}

_fixture_environment_variable_positions() {
  # $1: the test to parametrize

  case "${PARAMETRIZE_SCENARIO_NAME}" in
    all_specified_perms)
      TEST_VARIABLE_FOLDER_PAIR_DEFINITION="RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER:RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER_PERMISSION|1 RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER:RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER_PERMISSION|11"
      TEST_VARIABLE_PAIR_DEFINITION="RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH|3 RPI_BACKUP_JOB_NAME|5 RPI_BACKUP_JOB_REMOTE_PARAMETER|7 RPI_BACKUP_JOB_QUEUE|9 RPI_BACKUP_JOB_LOCAL_SOURCE|13 RPI_BACKUP_JOB_REMOTE_TARGET|15 RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS|17"
      ;;
    missing_tarball____)
      TEST_VARIABLE_FOLDER_PAIR_DEFINITION="RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER:RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER_PERMISSION|9"
      TEST_VARIABLE_PAIR_DEFINITION="RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH|1 RPI_BACKUP_JOB_NAME|3 RPI_BACKUP_JOB_REMOTE_PARAMETER|5 RPI_BACKUP_JOB_QUEUE|7 RPI_BACKUP_JOB_LOCAL_SOURCE|11 RPI_BACKUP_JOB_REMOTE_TARGET|13 RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS|15"
      ;;
    missing_encryption_)
      TEST_VARIABLE_FOLDER_PAIR_DEFINITION="RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER:RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER_PERMISSION|7"
      TEST_VARIABLE_PAIR_DEFINITION="RPI_BACKUP_JOB_NAME|1 RPI_BACKUP_JOB_REMOTE_PARAMETER|3 RPI_BACKUP_JOB_QUEUE|5 RPI_BACKUP_JOB_LOCAL_SOURCE|9 RPI_BACKUP_JOB_REMOTE_TARGET|11 RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS|13"
      ;;
    no_args____________)
      TEST_VARIABLE_PAIR_DEFINITION=""
      ;;
    invalid_arguments)
      TEST_VARIABLE_PAIR_DEFINITION="RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH|1"
      ;;
    *)
      _testing.error "Unknown scenario: ${PARAMETRIZE_SCENARIO_NAME}"
      ;;
  esac

  stdlib.array.make.from_string TEST_VARIABLE_PAIRS " " "${TEST_VARIABLE_PAIR_DEFINITION}"
  stdlib.array.make.from_string TEST_VARIABLE_FOLDER_PAIRS " " "${TEST_VARIABLE_FOLDER_PAIR_DEFINITION}"
}

test_backup_job_args__@vary__@vary__destination_path_and_permissions_variables_are_set_as_expected() {
  local command_args
  local variable_pair=()
  local variable_pair_definition
  local variable_pair_names=()
  local variable_pair_values=()
  local variable_pair_index

  stdlib.array.make.from_string command_args "|" "${TEST_ARGS_DEFINITION}"

  _backup_job_args "${command_args[@]}"

  for variable_pair_definition in "${TEST_VARIABLE_FOLDER_PAIRS[@]}"; do
    stdlib.array.make.from_string variable_pair "|" "${variable_pair_definition}"
    stdlib.array.make.from_string variable_pair_names ":" "${variable_pair[0]}"
    stdlib.array.make.from_string variable_pair_values ":" "${command_args[${variable_pair[1]}]}"
    for ((variable_pair_index = 0; variable_pair_index < "${#variable_pair_names[@]}"; variable_pair_index++)); do
      assert_equals "${variable_pair_values[variable_pair_index]}" "${!variable_pair_names[variable_pair_index]}"
    done
  done
}

@parametrize.apply \
  test_backup_job_args__@vary__@vary__destination_path_and_permissions_variables_are_set_as_expected \
  @parametrize_with_success_args \
  @parametrize_with_failure_args

test_backup_job_args__@vary__@vary__standard_variables_are_set_as_expected() {
  local command_args
  local variable_pair=()
  local variable_pair_definition

  stdlib.array.make.from_string command_args "|" "${TEST_ARGS_DEFINITION}"

  _backup_job_args "${command_args[@]}"

  for variable_pair_definition in "${TEST_VARIABLE_PAIRS[@]}"; do
    stdlib.array.make.from_string variable_pair "|" "${variable_pair_definition}"
    assert_equals "${!variable_pair[0]}" "${command_args[${variable_pair[1]}]}"
  done
}

@parametrize.apply \
  test_backup_job_args__@vary__@vary__standard_variables_are_set_as_expected \
  @parametrize_with_success_args \
  @parametrize_with_failure_args

test_backup_job_args__@vary__@vary__does_not_call_backup_job_usage() {
  local command_args

  stdlib.array.make.from_string command_args "|" "${TEST_ARGS_DEFINITION}"

  _backup_job_args "${command_args[@]}"

  _backup_job_usage.mock.assert_not_called
}

@parametrize.apply \
  test_backup_job_args__@vary__@vary__does_not_call_backup_job_usage \
  @parametrize_with_success_args

test_backup_job_args__@vary__@vary__calls_backup_job_usage() {
  local command_args

  stdlib.array.make.from_string command_args "|" "${TEST_ARGS_DEFINITION}"

  _backup_job_args "${command_args[@]}"

  _backup_job_usage.mock.assert_called_once_with ""
}

@parametrize.apply \
  test_backup_job_args__@vary__@vary__calls_backup_job_usage \
  @parametrize_with_failure_args

test_backup_job_args__@vary__@vary__calls_backup_job_validation_as_expected() {
  local command_args

  stdlib.array.make.from_string command_args "|" "${TEST_ARGS_DEFINITION}"

  _backup_job_args "${command_args[@]}"

  _backup_job_validation.mock.assert_called_once_with "1(_backup_job_usage)"
}

@parametrize.apply \
  test_backup_job_args__@vary__@vary__calls_backup_job_validation_as_expected \
  @parametrize_with_success_args \
  @parametrize_with_failure_args

test_backup_job_args__@vary__@vary__calls_backup_job_validation_queue_as_expected() {
  local command_args
  local variable_pair_definition

  stdlib.array.make.from_string command_args "|" "${TEST_ARGS_DEFINITION}"

  _backup_job_args "${command_args[@]}"

  for variable_pair_definition in "${TEST_VARIABLE_PAIRS[@]}"; do
    if stdlib.string.query.starts_with "RPI_BACKUP_JOB_QUEUE"; then
      _backup_job_validation_queue.mock.assert_called_once_with "${variable_pair_definition/"RPI_BACKUP_JOB_QUEUE|"/}"
    fi
  done
}

@parametrize.apply \
  test_backup_job_args__@vary__@vary__calls_backup_job_validation_queue_as_expected \
  @parametrize_with_success_args \
  @parametrize_with_failure_args
