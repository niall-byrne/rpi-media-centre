#!/bin/bash

setup() {
  _mock.create _cli_log_warning
  _mock.create _docker_compose_command
  _mock.create _service_cli_start

  _docker_compose_command.mock.set.keywords "_RPI_SERVICE_REMOVE_CONTAINERS"
  _service_cli_start.mock.set.keywords "_RPI_SERVICE_REMOVE_CONTAINERS"
}

test_service_cli_upgrade__logs_warning_message() {
  _service_cli_upgrade

  _cli_log_warning.mock.assert_called_once_with \
    "1(Media centre now being upgraded ...)"
}

test_service_cli_upgrade__calls_docker_compose_stop_and_pull() {
  _service_cli_upgrade

  _docker_compose_command.mock.assert_calls_are \
    "1(stop) _RPI_SERVICE_REMOVE_CONTAINERS(1)" \
    "1(pull) _RPI_SERVICE_REMOVE_CONTAINERS(1)"
}

test_service_cli_upgrade__calls_service_cli_start() {
  _service_cli_upgrade

  _service_cli_start.mock.assert_called_once_with \
    "_RPI_SERVICE_REMOVE_CONTAINERS(1)"
}

test_service_cli_upgrade__calls_dependencies_in_correct_sequence() {
  _mock.sequence.record.start

  _service_cli_upgrade

  _mock.sequence.assert_is \
    "_cli_log_warning" \
    "_docker_compose_command" \
    "_docker_compose_command" \
    "_service_cli_start"
}
