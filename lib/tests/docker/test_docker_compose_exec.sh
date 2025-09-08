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
    "TEST_TARGET_SERVICE;TEST_TARGET_COMMAND" \
    "plex___ls__;plex;ls" \
    "samba__bash;samba;bash|-c|'echo hello'"
}

test_docker_compose_exec__@vary__calls_the_correct_dependency_group() {
  local command_args=()

  stdlib.array.make.from_string command_args "|" "${TEST_TARGET_COMMAND}"

  _docker_compose_exec "${TEST_TARGET_SERVICE}" "${command_args[@]}"

  _dependencies_group_containers.mock.assert_called_once_with ""
}

@parametrize_with_services \
  test_docker_compose_exec__@vary__calls_the_correct_dependency_group

test_docker_compose_exec__@vary__changes_directory_as_expected() {
  local command_args=()

  stdlib.array.make.from_string command_args "|" "${TEST_TARGET_COMMAND}"

  _docker_compose_exec "${TEST_TARGET_SERVICE}" "${command_args[@]}"

  pushd.mock.assert_called_once_with "1(services)"
  popd.mock.assert_called_once_with ""
}

@parametrize_with_services \
  test_docker_compose_exec__@vary__changes_directory_as_expected

# shellcheck disable=SC2034
test_docker_compose_exec__@vary__calls_docker_compose_as_expected() {
  local command_args=()

  stdlib.array.make.from_string command_args "|" "${TEST_TARGET_COMMAND}"

  _docker_compose_exec "${TEST_TARGET_SERVICE}" "${command_args[@]}"

  command_args=("compose" "exec" "${TEST_TARGET_SERVICE}" "${command_args[@]}")
  docker.mock.assert_called_once_with \
    "$(_mock.arg_string.from_array command_args)"
}

@parametrize_with_services \
  test_docker_compose_exec__@vary__calls_docker_compose_as_expected

# shellcheck disable=SC2034
test_docker_compose_exec__@vary__executes_binary_calls_in_expected_sequence() {
  local command_args=()
  local expected_mock_sequence=(
    "_dependencies_group_containers"
    "pushd"
    "docker"
    "popd"
  )

  stdlib.array.make.from_string command_args "|" "${TEST_TARGET_COMMAND}"
  _mock.sequence.record.start

  _docker_compose_exec "${TEST_TARGET_SERVICE}" "${command_args[@]}"

  _mock.sequence.assert_is \
    "${expected_mock_sequence[@]}"
}

@parametrize_with_services \
  test_docker_compose_exec__@vary__executes_binary_calls_in_expected_sequence
