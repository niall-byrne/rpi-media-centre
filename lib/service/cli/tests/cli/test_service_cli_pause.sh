#!/bin/bash

setup() {
  _mock.create _cli_log_warning
  _mock.create _docker_compose_command

  _docker_compose_command.mock.set.keywords "_RPI_SERVICE_REMOVE_CONTAINERS"
}

test_service_cli_pause__logs_warning_message() {
  _service_cli_pause

  _cli_log_warning.mock.assert_called_once_with \
    "1(Media centre now being paused ...)"
}

test_service_cli_pause__calls_docker_compose_stop() {
  _service_cli_pause

  _docker_compose_command.mock.assert_called_once_with \
    "1(stop) _RPI_SERVICE_REMOVE_CONTAINERS(0)"
}

test_service_cli_pause__calls_dependencies_in_correct_sequence() {
  _mock.sequence.record.start

  _service_cli_pause

  _mock.sequence.assert_is \
    "_cli_log_warning" \
    "_docker_compose_command"
}
