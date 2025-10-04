#!/bin/bash

setup() {
  _mock.create _cli_log_warning
  _mock.create _docker_compose_command
  _mock.create _disk_manifest_command_unmount

  _docker_compose_command.mock.set.keywords "_RPI_SERVICE_REMOVE_CONTAINERS"
}

test_service_cli_stop__logs_warning_message() {
  _service_cli_stop

  _cli_log_warning.mock.assert_called_once_with \
    "1(Media centre now stopping ...)"
}

test_service_cli_stop__calls_docker_compose_stop() {
  _service_cli_stop

  _docker_compose_command.mock.assert_called_once_with \
    "1(stop) _RPI_SERVICE_REMOVE_CONTAINERS(1)"
}

test_service_cli_stop__unmounts_all_disks() {
  _service_cli_stop

  _disk_manifest_command_unmount.mock.assert_called_once_with ""
}

test_service_cli_stop__calls_dependencies_in_correct_sequence() {
  _mock.sequence.record.start

  _service_cli_stop

  _mock.sequence.assert_is \
    "_cli_log_warning" \
    "_docker_compose_command" \
    "_disk_manifest_command_unmount"
}
