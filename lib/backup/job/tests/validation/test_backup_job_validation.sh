#!/bin/bash

setup() {
  _mock.create _mock_help_function
  _mock.create _cli_log_error
  _mock.create _cli_log_success
  _mock.create _backup_job_log

  _mock.create _backup_job_validation_path
  _mock.create _dependencies_group_backups_rsync

  _mock.create _backup_job_validation_tarball_versions
  _mock.create _dependencies_group_backups_tarball

  _mock.create _backup_job_validation_source

  _mock.create _backup_job_validation_key_file

  _mock.create _backup_job_validation_remote_target

  _mock_help_function.mock.set.stdout "mocked help message"
}

teardown() {
  unset RPI_BACKUP_JOB_NAME
  unset RPI_BACKUP_JOB_GROUP
  unset RPI_BACKUP_JOB_LOCAL_SOURCE
  unset RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER
  unset RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER
  unset RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS
  unset RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH
  unset RPI_BACKUP_JOB_REMOTE_TARGET
  unset RPI_BACKUP_JOB_REMOTE_PARAMETER
}

_fixture_set_variable_content() {
  local variable_name
  local variable_names=()

  stdlib.array.make.from_string variable_names "|" "${TEST_VARIABLE_NAMES_DEFINITION}"

  for variable_name in "${variable_names[@]}"; do
    printf -v "RPI_BACKUP_JOB_${variable_name}" "%s" "${variable_name}"
  done
}

_fixture_set_variable_content_except() {
  # $@: the variables to exclude from being defined

  local variable_name
  local variable_names=()

  TEST_VARIABLE_NAMES_DEFINITION="NAME|GROUP|LOCAL_SOURCE|LOCAL_RSYNC_FOLDER|LOCAL_TARBALL_FOLDER|LOCAL_TARBALL_VERSIONS|REMOTE_ENCRYPTION_KEY_PATH|REMOTE_TARGET|REMOTE_PARAMETER"

  _fixture_set_variable_content

  for variable_name in "${@}"; do
    unset "RPI_BACKUP_JOB_${variable_name}"
  done
}

@parametrize_with_all_arguments() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_VARIABLE_NAMES_DEFINITION" \
    "everything_defined;NAME|GROUP|LOCAL_SOURCE|LOCAL_RSYNC_FOLDER|LOCAL_TARBALL_FOLDER|LOCAL_TARBALL_VERSIONS|REMOTE_ENCRYPTION_KEY_PATH|REMOTE_TARGET|REMOTE_PARAMETER"
}

@parametrize_with_invalid_arguments() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_VARIABLE_NAMES_DEFINITION" \
    "name_is_undefined;GROUP|LOCAL_SOURCE|LOCAL_RSYNC_FOLDER|LOCAL_TARBALL_FOLDER|LOCAL_TARBALL_VERSIONS|REMOTE_ENCRYPTION_KEY_PATH|REMOTE_TARGET|REMOTE_PARAMETER" \
    "group_is_undefined;NAME|LOCAL_SOURCE|LOCAL_RSYNC_FOLDER|LOCAL_TARBALL_FOLDER|LOCAL_TARBALL_VERSIONS|REMOTE_ENCRYPTION_KEY_PATH|REMOTE_TARGET|REMOTE_PARAMETER" \
    "no_task_defined;NAME|GROUP|LOCAL_RSYNC_FOLDER|LOCAL_TARBALL_FOLDER|LOCAL_TARBALL_VERSIONS|REMOTE_ENCRYPTION_KEY_PATH|REMOTE_TARGET|REMOTE_PARAMETER" \
    "source_is_undefined;NAME|GROUP|LOCAL_SOURCE" \
    "tarball_without_version_count;NAME|GROUP|LOCAL_SOURCE|LOCAL_RSYNC_FOLDER|LOCAL_TARBALL_FOLDER|REMOTE_ENCRYPTION_KEY_PATH|REMOTE_TARGET|REMOTE_PARAMETER" \
    "version_count_without_tarball;NAME|GROUP|LOCAL_SOURCE|LOCAL_RSYNC_FOLDER|LOCAL_TARBALL_FOLDER|REMOTE_ENCRYPTION_KEY_PATH|REMOTE_TARGET|REMOTE_PARAMETER" \
    "remote_parameter_without_remote_target;NAME|GROUP|LOCAL_SOURCE|LOCAL_RSYNC_FOLDER|LOCAL_TARBALL_FOLDER|LOCAL_TARBALL_VERSIONS|REMOTE_PARAMETER" \
    "encryption_key_without_remote_target;NAME|GROUP|LOCAL_SOURCE|LOCAL_RSYNC_FOLDER|LOCAL_TARBALL_FOLDER|LOCAL_TARBALL_VERSIONS|REMOTE_ENCRYPTION_KEY_PATH"
}

@parametrize_with_logging_toggle() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_JOB_LOGGING_TOGGLE_VALUE" \
    "job_log_enabled_;1" \
    "job_log_disabled;;"
}

test_backup_job_validation__@vary__@vary__logs_invalid_job_error() {
  _fixture_set_variable_content

  _backup_job_validation _mock_help_function "${TEST_JOB_LOGGING_TOGGLE_VALUE}" 2> /dev/null

  _cli_log_error.mock.assert_called_once_with \
    "1( -- BACKUP JOB: Backup Job is INVALID!)"
}

@parametrize.compose \
  test_backup_job_validation__@vary__@vary__logs_invalid_job_error \
  @parametrize_with_logging_toggle \
  @parametrize_with_invalid_arguments

test_backup_job_validation__@vary__@vary__calls_the_help_function() {
  _fixture_set_variable_content

  _backup_job_validation _mock_help_function "${TEST_JOB_LOGGING_TOGGLE_VALUE}" 2> /dev/null

  _mock_help_function.mock.assert_called_once_with ""
}

@parametrize.compose \
  test_backup_job_validation__@vary__@vary__calls_the_help_function \
  @parametrize_with_logging_toggle \
  @parametrize_with_invalid_arguments

test_backup_job_validation__@vary__@vary__outputs_help_function_contents_to_stderr() {
  _fixture_set_variable_content

  _capture.stderr _backup_job_validation _mock_help_function "${TEST_JOB_LOGGING_TOGGLE_VALUE}"

  assert_output "mocked help message"
}

@parametrize.compose \
  test_backup_job_validation__@vary__@vary__outputs_help_function_contents_to_stderr \
  @parametrize_with_logging_toggle \
  @parametrize_with_invalid_arguments

test_backup_job_validation__job_log_enabled___@vary______________________logs_success_message() {
  _fixture_set_variable_content

  _backup_job_validation _mock_help_function "1"

  _cli_log_success.mock.assert_called_once_with \
    "1( -- BACKUP JOB: Backup Job is VALID!)"
}

@parametrize.compose \
  test_backup_job_validation__job_log_enabled___@vary______________________logs_success_message \
  @parametrize_with_all_arguments

test_backup_job_validation__job_log_disabled__@vary______________________does_not_log_a_message() {
  _fixture_set_variable_content

  _backup_job_validation _mock_help_function

  _cli_log_success.mock.assert_not_called
}

@parametrize.compose \
  test_backup_job_validation__job_log_disabled__@vary______________________does_not_log_a_message \
  @parametrize_with_all_arguments

test_backup_job_validation__@vary__@vary______________________performs_local_rsync_path_validation() {
  _fixture_set_variable_content

  _backup_job_validation _mock_help_function

  _backup_job_validation_path.mock.assert_calls_are \
    "1(LOCAL_RSYNC_FOLDER)" \
    "1(LOCAL_TARBALL_FOLDER)"
}

@parametrize.compose \
  test_backup_job_validation__@vary__@vary______________________performs_local_rsync_path_validation \
  @parametrize_with_logging_toggle \
  @parametrize_with_all_arguments

test_backup_job_validation__@vary__without_rsync___________________________skips_rsync_path_validation() {
  _fixture_set_variable_content_except "LOCAL_RSYNC_FOLDER"

  _backup_job_validation _mock_help_function

  _backup_job_validation_path.mock.assert_calls_are \
    "1(LOCAL_TARBALL_FOLDER)"
}

@parametrize.compose \
  test_backup_job_validation__@vary__without_rsync___________________________skips_rsync_path_validation \
  @parametrize_with_logging_toggle

test_backup_job_validation__@vary__@vary______________________performs_local_tarball_path_validation() {
  _fixture_set_variable_content

  _backup_job_validation _mock_help_function

  _backup_job_validation_path.mock.assert_calls_are \
    "1(LOCAL_RSYNC_FOLDER)" \
    "1(LOCAL_TARBALL_FOLDER)"
}

@parametrize.compose \
  test_backup_job_validation__@vary__@vary______________________performs_local_tarball_path_validation \
  @parametrize_with_logging_toggle \
  @parametrize_with_all_arguments

test_backup_job_validation__@vary__@vary______________________performs_local_tarball_version_count_validation() {
  _fixture_set_variable_content

  _backup_job_validation _mock_help_function

  _backup_job_validation_tarball_versions.mock.assert_called_once_with \
    "1(LOCAL_TARBALL_VERSIONS)"
}

@parametrize.compose \
  test_backup_job_validation__@vary__@vary______________________performs_local_tarball_version_count_validation \
  @parametrize_with_logging_toggle \
  @parametrize_with_all_arguments

test_backup_job_validation__@vary__@vary______________________performs_tarball_dependency_check() {
  _fixture_set_variable_content

  _backup_job_validation _mock_help_function

  _dependencies_group_backups_tarball.mock.assert_called_once_with ""
}

@parametrize.compose \
  test_backup_job_validation__@vary__@vary______________________performs_tarball_dependency_check \
  @parametrize_with_logging_toggle \
  @parametrize_with_all_arguments

test_backup_job_validation__@vary__without_tarball_________________________skips_local_tarball_path_validation() {
  _fixture_set_variable_content_except "LOCAL_TARBALL_FOLDER" "LOCAL_TARBALL_VERSIONS"

  _backup_job_validation _mock_help_function

  _backup_job_validation_path.mock.assert_calls_are \
    "1(LOCAL_RSYNC_FOLDER)"
}

@parametrize.compose \
  test_backup_job_validation__@vary__without_tarball_________________________skips_local_tarball_path_validation \
  @parametrize_with_logging_toggle

test_backup_job_validation__@vary__without_tarball_________________________skips_local_tarball_version_count_validation() {
  _fixture_set_variable_content_except "LOCAL_TARBALL_FOLDER" "LOCAL_TARBALL_VERSIONS"

  _backup_job_validation _mock_help_function

  _backup_job_validation_tarball_versions.mock.assert_not_called
}

@parametrize.compose \
  test_backup_job_validation__@vary__without_tarball_________________________skips_local_tarball_version_count_validation \
  @parametrize_with_logging_toggle

test_backup_job_validation__@vary__without_tarball_________________________skips_tarball_dependency_check() {
  _fixture_set_variable_content_except "LOCAL_TARBALL_FOLDER" "LOCAL_TARBALL_VERSIONS"

  _backup_job_validation _mock_help_function

  _dependencies_group_backups_tarball.mock.assert_not_called
}

@parametrize.compose \
  test_backup_job_validation__@vary__without_tarball_________________________skips_tarball_dependency_check \
  @parametrize_with_logging_toggle

test_backup_job_validation__@vary__@vary______________________performs_source_validation() {
  _fixture_set_variable_content

  _backup_job_validation _mock_help_function

  _backup_job_validation_source.mock.assert_called_once_with \
    "1(LOCAL_SOURCE)"
}

@parametrize.compose \
  test_backup_job_validation__@vary__@vary______________________performs_source_validation \
  @parametrize_with_logging_toggle \
  @parametrize_with_all_arguments

test_backup_job_validation__@vary__@vary______________________performs_remote_encryption_key_path_validation() {
  _fixture_set_variable_content

  _backup_job_validation _mock_help_function

  _backup_job_validation_key_file.mock.assert_called_once_with \
    "1(REMOTE_ENCRYPTION_KEY_PATH)"
}

@parametrize.compose \
  test_backup_job_validation__@vary__@vary______________________performs_remote_encryption_key_path_validation \
  @parametrize_with_logging_toggle \
  @parametrize_with_all_arguments

test_backup_job_validation__@vary__without_key_file________________________skips_remote_encryption_key_path_validation() {
  _fixture_set_variable_content_except "REMOTE_ENCRYPTION_KEY_PATH"

  _backup_job_validation _mock_help_function

  _backup_job_validation_key_file.mock.assert_not_called
}

@parametrize.compose \
  test_backup_job_validation__@vary__without_key_file________________________skips_remote_encryption_key_path_validation \
  @parametrize_with_logging_toggle

test_backup_job_validation__@vary__@vary______________________performs_remote_path_validation() {
  _fixture_set_variable_content

  _backup_job_validation _mock_help_function

  _backup_job_validation_remote_target.mock.assert_called_once_with \
    "1(REMOTE_TARGET) 2(REMOTE_PARAMETER)"
}

@parametrize.compose \
  test_backup_job_validation__@vary__@vary______________________performs_remote_path_validation \
  @parametrize_with_logging_toggle \
  @parametrize_with_all_arguments
