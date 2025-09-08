#!/bin/bash

setup() {
  _mock.create _dependencies_group_containers
  _mock.create docker
  _mock.create pushd
  _mock.create popd
}

@parametrize_with_services() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ENABLED_SERVICES;_SERVICE_REMOVE_CONTAINERS;TEST_DOCKER_ARGS_DEFINITION" \
    "one_service____do_not_remove_containers;samba;0;1(compose) 2(--profile) 3(samba) 4(test_command)" \
    "one_service____remove_containers_______;samba;1;1(compose) 2(--profile) 3(samba) 4(test_command)|1(compose) 2(--profile) 3(samba) 4(rm) 5(-f)" \
    "two_services___do_not_remove_containers;plex|samba;0;1(compose) 2(--profile) 3(plex) 4(--profile) 5(samba) 6(test_command)" \
    "two_services___remove_containers_______;plex|samba;1;1(compose) 2(--profile) 3(plex) 4(--profile) 5(samba) 6(test_command)|1(compose) 2(--profile) 3(plex) 4(--profile) 5(samba) 6(rm) 7(-f)"
}

# shellcheck disable=SC2034
test_docker_compose_command__@vary__calls_the_correct_dependency_group() {
  local RPI_SERVICES

  stdlib.array.make.from_string RPI_SERVICES "|" "${TEST_ENABLED_SERVICES}"

  _docker_compose_command "test_command"

  _dependencies_group_containers.mock.assert_called_once_with ""
}

# shellcheck disable=SC2034
test_docker_compose_command__@vary__changes_directory_as_expected() {
  local RPI_SERVICES

  stdlib.array.make.from_string RPI_SERVICES "|" "${TEST_ENABLED_SERVICES}"

  _docker_compose_command "test_command"

  pushd.mock.assert_called_once_with "1(services)"
  popd.mock.assert_called_once_with ""
}

@parametrize_with_services \
  test_docker_compose_command__@vary__changes_directory_as_expected

# shellcheck disable=SC2034
test_docker_compose_command__@vary__calls_docker_compose_as_expected() {
  local RPI_SERVICES
  local expected_docker_compose_args

  stdlib.array.make.from_string RPI_SERVICES "|" "${TEST_ENABLED_SERVICES}"
  stdlib.array.make.from_string expected_docker_compose_args "|" "${TEST_DOCKER_ARGS_DEFINITION}"

  _docker_compose_command "test_command"

  docker.mock.assert_calls_are \
    "${expected_docker_compose_args[@]}"
}

@parametrize_with_services \
  test_docker_compose_command__@vary__calls_docker_compose_as_expected

# shellcheck disable=SC2034
test_docker_compose_command__@vary__executes_binary_calls_in_expected_sequence() {
  local RPI_SERVICES
  local expected_mock_sequence=(
    "_dependencies_group_containers"
    "pushd"
    "docker"
    "popd"
  )

  stdlib.array.make.from_string RPI_SERVICES "|" "${TEST_ENABLED_SERVICES}"
  if [[ "${_SERVICE_REMOVE_CONTAINERS}" == "1" ]]; then
    stdlib.array.mutate.insert "docker" "3" expected_mock_sequence
  fi
  _mock.sequence.record.start

  _docker_compose_command "test_command"

  _mock.sequence.assert_is \
    "${expected_mock_sequence[@]}"
}

@parametrize_with_services \
  test_docker_compose_command__@vary__executes_binary_calls_in_expected_sequence
