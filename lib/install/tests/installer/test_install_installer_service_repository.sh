#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/install/installer.sh"

setup() {
  _mock.create _cli_log_warning
  _mock.create _cli_log_success
  _mock.create stdlib.security.path.make.dir
  _mock.create stdlib.io.path.query.is_folder
  _mock.create sudo
  _mock.create rm

  cd "${RPI_WORKING_DIRECTORY}" || return 127
}

teardown() {
  _mock.delete rm
}

@parametrize_with_repository_state() {
  # $1: the test function being parametrized

  @parametrize \
    "${1}" \
    "TEST_FOLDER_RC;" \
    "when_repo_exists________;0" \
    "when_repo_does_not_exist;1"
}

@parametrize_with_repository_scenarios() {
  # $1: the test function being parametrized

  @parametrize \
    "${1}" \
    "TEST_FOLDER;TEST_ARGS_DEFINITION;TEST_USERNAME;TEST_GROUPNAME;TEST_EXPECTED_SHA" \
    "user1__no_sha;/tmp/test1;;user1;group1;origin/main" \
    "user1__sha___;/tmp/test2;mock_sha;user1;group1;mock_sha" \
    "user2__no_sha;/tmp/test3;;user2;group2;origin/main" \
    "user2__sha___;/tmp/test4;mock_sha;user2;group2;mock_sha"
}

# shellcheck disable=SC2034
test_install_installer_service_repository__@vary__@vary__logs_warning_message() {
  local command_args=()
  local RPI_REPOSITORY_LOCATION="${TEST_FOLDER}"
  local RPI_SVC_USERNAME="${TEST_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_GROUPNAME}"

  stdlib.array.make.from_string command_args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.io.path.query.is_folder.mock.set.rc "${TEST_FOLDER_RC}"

  _installer_service_repository "${command_args[@]}"

  _cli_log_warning.mock.assert_called_once_with \
    "1(INSTALLER: Installing repository to ${RPI_REPOSITORY_LOCATION} ...)"
}

@parametrize.compose \
  test_install_installer_service_repository__@vary__@vary__logs_warning_message \
  @parametrize_with_repository_state \
  @parametrize_with_repository_scenarios

# shellcheck disable=SC2034
test_install_installer_service_repository__@vary__@vary__makes_repository_folder() {
  local command_args=()
  local RPI_REPOSITORY_LOCATION="${TEST_FOLDER}"
  local RPI_SVC_USERNAME="${TEST_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_GROUPNAME}"

  stdlib.array.make.from_string command_args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.io.path.query.is_folder.mock.set.rc "${TEST_FOLDER_RC}"

  _installer_service_repository "${command_args[@]}"

  stdlib.security.path.make.dir.mock.assert_called_once_with \
    "1(${TEST_FOLDER}) 2(${TEST_USERNAME}) 3(${TEST_GROUPNAME}) 4(700)"
}

@parametrize.compose \
  test_install_installer_service_repository__@vary__@vary__makes_repository_folder \
  @parametrize_with_repository_state \
  @parametrize_with_repository_scenarios

# shellcheck disable=SC2034
test_install_installer_service_repository__@vary__@vary__checks_for_git_folder() {
  local command_args=()
  local RPI_REPOSITORY_LOCATION="${TEST_FOLDER}"
  local RPI_SVC_USERNAME="${TEST_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_GROUPNAME}"

  stdlib.array.make.from_string command_args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.io.path.query.is_folder.mock.set.rc "${TEST_FOLDER_RC}"

  _installer_service_repository "${command_args[@]}"

  stdlib.io.path.query.is_folder.mock.assert_called_once_with \
    "1(${TEST_FOLDER}/source/.git)"
}

@parametrize.compose \
  test_install_installer_service_repository__@vary__@vary__checks_for_git_folder \
  @parametrize_with_repository_state \
  @parametrize_with_repository_scenarios

# shellcheck disable=SC2034
test_install_installer_service_repository__when_repo_exists__________@vary__handles_sudo_calls() {
  local command_args=()
  local RPI_REPOSITORY_LOCATION="${TEST_FOLDER}"
  local RPI_SVC_USERNAME="${TEST_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_GROUPNAME}"

  stdlib.array.make.from_string command_args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.io.path.query.is_folder.mock.set.rc 0

  _installer_service_repository "${command_args[@]}"

  sudo.mock.assert_calls_are \
    "1(chown) 2(${TEST_USERNAME}:${TEST_GROUPNAME}) 3(-R) 4(${TEST_FOLDER}/source)" \
    "1(-u) 2(${TEST_USERNAME}) 3(bash) 4(-c) 5(
      cd '${TEST_FOLDER}/source' &&
      git fetch &&
      git reset --hard '${TEST_EXPECTED_SHA}'
    )"
}

@parametrize_with_repository_scenarios \
  test_install_installer_service_repository__when_repo_exists__________@vary__handles_sudo_calls

test_install_installer_service_repository__when_repo_exists__________@vary__removes_compiled_files() {
  local command_args=()
  local RPI_REPOSITORY_LOCATION="${TEST_FOLDER}"
  local RPI_SVC_USERNAME="${TEST_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_GROUPNAME}"

  stdlib.array.make.from_string command_args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.io.path.query.is_folder.mock.set.rc 0

  _installer_service_repository "${command_args[@]}"

  rm.mock.assert_called_once_with \
    "1(-f) 2(${TEST_FOLDER}/source/lib/cli/build/*)"
}

@parametrize_with_repository_scenarios \
  test_install_installer_service_repository__when_repo_exists__________@vary__removes_compiled_files

# shellcheck disable=SC2034
test_install_installer_service_repository__when_repo_does_not_exist__@vary__handles_sudo_calls() {
  local command_args=()
  local RPI_REPOSITORY_LOCATION="${TEST_FOLDER}"
  local RPI_SVC_USERNAME="${TEST_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_GROUPNAME}"

  stdlib.array.make.from_string command_args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.io.path.query.is_folder.mock.set.rc 1

  _installer_service_repository "${command_args[@]}"

  sudo.mock.assert_called_once_with \
    "1(-u) 2(${TEST_USERNAME}) 3(bash) 4(-c) 5(
      cd '${TEST_FOLDER}' &&
      git clone '${RPI_INSTALLER_REPOSITORY_SOURCE}' 'source' &&
      cd 'source' &&
      git reset --hard '${TEST_EXPECTED_SHA}'
    )"
}

@parametrize_with_repository_scenarios \
  test_install_installer_service_repository__when_repo_does_not_exist__@vary__handles_sudo_calls

# shellcheck disable=SC2034
test_install_installer_service_repository__when_repo_does_not_exist__@vary__does_not_remove_files() {
  local command_args=()
  local RPI_REPOSITORY_LOCATION="${TEST_FOLDER}"
  local RPI_SVC_USERNAME="${TEST_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_GROUPNAME}"

  stdlib.array.make.from_string command_args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.io.path.query.is_folder.mock.set.rc 1

  _installer_service_repository "${command_args[@]}"

  rm.mock.assert_not_called
}

@parametrize_with_repository_scenarios \
  test_install_installer_service_repository__when_repo_does_not_exist__@vary__does_not_remove_files

# shellcheck disable=SC2034
test_install_installer_service_repository__@vary__@vary__logs_success_message() {
  local command_args=()
  local RPI_REPOSITORY_LOCATION="${TEST_FOLDER}"
  local RPI_SVC_USERNAME="${TEST_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_GROUPNAME}"

  stdlib.array.make.from_string command_args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.io.path.query.is_folder.mock.set.rc "${TEST_FOLDER_RC}"

  _installer_service_repository "${command_args[@]}"

  _cli_log_success.mock.assert_called_once_with \
    "1(INSTALLER: Repository has been installed to ${RPI_REPOSITORY_LOCATION} !)"
}

@parametrize.compose \
  test_install_installer_service_repository__@vary__@vary__logs_success_message \
  @parametrize_with_repository_state \
  @parametrize_with_repository_scenarios
