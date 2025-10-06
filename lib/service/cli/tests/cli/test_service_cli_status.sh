#!/bin/bash

setup() {
  _mock.create _docker_compose_command

  _docker_compose_command.mock.set.keywords "_RPI_SERVICE_REMOVE_CONTAINERS"
}

test_service_cli_status__calls_docker_compose_ps() {
  _service_cli_status

  _docker_compose_command.mock.assert_called_once_with \
    "1(ps) 2(-a) _RPI_SERVICE_REMOVE_CONTAINERS(0)"
}

test_service_cli_status__calls_dependencies_in_correct_sequence() {
  _mock.sequence.record.start

  _service_cli_status

  _mock.sequence.assert_is \
    "_docker_compose_command"
}
