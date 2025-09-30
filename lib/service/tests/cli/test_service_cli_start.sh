#!/bin/bash

setup() {
  _mock.create _cli_log_warning
  _mock.create _disk_manifest_mount_all
  _mock.create _disk_initialize_mounts
  _mock.create _service_configuration
  _mock.create _docker_compose_command

  _docker_compose_command.mock.set.keywords "_RPI_SERVICE_REMOVE_CONTAINERS"
}

test_service_cli_start__logs_warning_message() {
  _service_cli_start

  _cli_log_warning.mock.assert_called_once_with \
    "1(Media centre now starting ...)"
}

test_service_cli_start__mounts_all_disks() {
  _service_cli_start

  _disk_manifest_mount_all.mock.assert_called_once_with ""
}

test_service_cli_start__initializes_mounts() {
  _service_cli_start

  _disk_initialize_mounts.mock.assert_called_once_with ""
}

test_service_cli_start__configures_docker_services() {
  _service_cli_start

  _service_configuration.mock.assert_calls_are \
    "1(pihole) 2(samba)" \
    "1(syncthing)"
}

test_service_cli_start__starts_docker_service_correct() {
  _service_cli_start

  _docker_compose_command.mock.assert_called_once_with \
    "1(up) 2(-d) _RPI_SERVICE_REMOVE_CONTAINERS(0)"
}

test_service_cli_start__calls_dependencies_in_correct_sequence() {
  _mock.sequence.record.start

  _service_cli_start

  _mock.sequence.assert_is \
    "_cli_log_warning" \
    "_disk_manifest_mount_all" \
    "_disk_initialize_mounts" \
    "_service_configuration" \
    "_docker_compose_command" \
    "_service_configuration"
}
