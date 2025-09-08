#!/bin/bash

setup_suite() {
  mock_envfile="$(mktemp)"
}

teardown_suite() {
  rm "${mock_envfile}"
}

setup() {
  _mock.create stdlib.security.path.secure
}

# shellcheck disable=SC2034
_fixture_mocked_environment_variables() {
  MOCK_ENVIRONMENT_VARIABLE_1="mock_value_1"
  MOCK_ENVIRONMENT_VARIABLE_2="mock_value_2"
  MOCK_VARIABLE_3="mock_value_3"
}

@parametrize_with_variable_patterns() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_PATTERN;TEST_EXPECTED_FILE_CONTENT" \
    "with_matching_variables___;MOCK_ENVIRONMENT_;MOCK_ENVIRONMENT_VARIABLE_1=\\\"mock_value_1\\\"<br>MOCK_ENVIRONMENT_VARIABLE_2=\\\"mock_value_2\\\"" \
    "without_matching_variables;NON_MATCHING_MOCK_ENVIRONMENT_;;"
}

test_docker_compose_filtered_env__@vary__creates_specified_env_file_correctly() {
  _fixture_mocked_environment_variables

  _docker_compose_filtered_env "${TEST_PATTERN}" "${mock_envfile}"

  assert_equals \
    "${TEST_EXPECTED_FILE_CONTENT/<br>/$'\n'}" \
    "$(cat "${mock_envfile}")"
}

@parametrize_with_variable_patterns \
  test_docker_compose_filtered_env__@vary__creates_specified_env_file_correctly

test_docker_compose_filtered_env__@vary__secures_created_env_file_correctly() {
  _fixture_mocked_environment_variables

  _docker_compose_filtered_env "${TEST_PATTERN}" "${mock_envfile}"

  stdlib.security.path.secure.mock.assert_called_once_with \
    "1(${mock_envfile}) 2(root) 3(root) 4(600)"
}

@parametrize_with_variable_patterns \
  test_docker_compose_filtered_env__@vary__secures_created_env_file_correctly

# shellcheck disable=SC2034
test_docker_compose_filtered_env__@vary__appends_env_file_to_cleanup_paths() {
  local RPI_EXIT_CLEANUP_PATHS=()
  local expected_cleanup_paths=("${mock_envfile}")

  _fixture_mocked_environment_variables

  _docker_compose_filtered_env "${TEST_PATTERN}" "${mock_envfile}"

  assert_array_equals expected_cleanup_paths RPI_EXIT_CLEANUP_PATHS
}

@parametrize_with_variable_patterns \
  test_docker_compose_filtered_env__@vary__appends_env_file_to_cleanup_paths
