#!/bin/bash

setup() {
  _mock.create _cli_log_warning
  _mock.create _configuration_service_syncthing_healthcheck
  _mock.create _docker_compose_exec
  _mock.create docker
  _mock.create _cli_log_success
}

@parametrize_with_credentials() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_USERNAME;TEST_PASSWORD;TEST_UID;TEST_GID" \
    "user1;user1;password1;1001;2001" \
    "user2;user2;password2;1101;2101"
}

test_configuration_service_syncthing__logs_warning_message() {
  _configuration_service_syncthing

  _cli_log_warning.mock.assert_called_once_with \
    "1(Configuring syncthing service credentials...)"
}

test_configuration_service_syncthing__calls_syncthing_healthcheck_twice() {
  _configuration_service_syncthing

  _configuration_service_syncthing_healthcheck.mock.assert_calls_are \
    "" \
    ""
}

# shellcheck disable=SC2034
test_configuration_service_syncthing__@vary__calls_docker_compose_exec_as_expected() {
  local RPI_SVC_UID="${TEST_UID}"
  local RPI_SVC_GID="${TEST_GID}"
  local RPI_SYNCTHING_CREDENTIALS_PASSWORD="${TEST_PASSWORD}"
  local RPI_SYNCTHING_CREDENTIALS_USERNAME="${TEST_USERNAME}"

  _configuration_service_syncthing

  _docker_compose_exec.mock.assert_calls_are \
    "1(syncthing) 2(syncthing) 3(generate) 4(--gui-password=${TEST_PASSWORD}) 5(--gui-user=${TEST_USERNAME})" \
    "1(syncthing) 2(chown) 3(${TEST_UID}:${TEST_GID}) 4(/config/config.xml)"
}

@parametrize_with_credentials \
  test_configuration_service_syncthing__@vary__calls_docker_compose_exec_as_expected

# shellcheck disable=SC2034
test_configuration_service_syncthing__restarts_the_syncthing_service() {
  _configuration_service_syncthing

  docker.mock.assert_called_once_with \
    "1(restart) 2(syncthing)"
}

test_configuration_service_syncthing__logs_success_message() {
  _configuration_service_syncthing

  _cli_log_success.mock.assert_called_once_with \
    "1(Configuration complete!)"
}

# shellcheck disable=SC2034
test_configuration_service_syncthing__calls_dependencies_in_the_correct_sequence() {
  _mock.sequence.record.start

  _configuration_service_syncthing

  _mock.sequence.assert_is \
    "_cli_log_warning" \
    "_configuration_service_syncthing_healthcheck" \
    "_docker_compose_exec" \
    "_docker_compose_exec" \
    "docker" \
    "_configuration_service_syncthing_healthcheck" \
    "_cli_log_success"
}
