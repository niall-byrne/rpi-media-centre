#!/bin/bash

setup() {
  _mock.create _docker_compose_command
}

test_service_cli_logs__calls_docker_compose_logs() {
  _service_cli_logs

  _docker_compose_command.mock.assert_called_once_with \
    "1(logs) 2(-f)"
}

test_service_cli_logs__calls_dependencies_in_correct_sequence() {
  _mock.sequence.record.start

  _service_cli_logs

  _mock.sequence.assert_is \
    "_docker_compose_command"
}
