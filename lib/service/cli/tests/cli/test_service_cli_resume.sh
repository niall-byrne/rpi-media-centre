#!/bin/bash

setup() {
  _mock.create _is_disk_mounted_all
  _mock.create _cli_log_warning
  _mock.create _docker_compose_command

  _docker_compose_command.mock.set.keywords "_RPI_SERVICE_REMOVE_CONTAINERS"
}

test_service_cli_resume__checks_if_disks_are_mounted() {
  _service_cli_resume

  _is_disk_mounted_all.mock.assert_called_once_with ""
}

test_service_cli_resume__logs_warning_message() {
  _service_cli_resume

  _cli_log_warning.mock.assert_called_once_with \
    "1(Media centre now being resumed ...)"
}

test_service_cli_resume__calls_docker_compose_start() {
  _service_cli_resume

  _docker_compose_command.mock.assert_called_once_with \
    "1(start) _RPI_SERVICE_REMOVE_CONTAINERS(0)"
}

test_service_cli_resume__calls_dependencies_in_correct_sequence() {
  _mock.sequence.record.start

  _service_cli_resume

  _mock.sequence.assert_is \
    "_is_disk_mounted_all" \
    "_cli_log_warning" \
    "_docker_compose_command"
}
