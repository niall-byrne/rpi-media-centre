#!/bin/bash

setup() {
  _mock.create _cli_log_warning
  _mock.create _disk_manifest_mount_all
  _mock.create _disk_initialize_mounts
  _mock.create _docker_is_service_selected
  _mock.create _configuration_samba
  _mock.create _configuration_pihole
  _mock.create _docker_compose_command
  _mock.create _configuration_syncthing
}

@parametrize_with_all() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ENABLED_SERVICES_DEFINITION;TEST_EXPECTED_SEQUENCE_DEFINITION" \
    "all_services_enabled__;samba|pihole|syncthing;_cli_log_warning|_disk_manifest_mount_all|_disk_initialize_mounts|_configuration_pihole|_configuration_samba|_docker_compose_command|_configuration_syncthing"
}

@parametrize_with_pihole() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ENABLED_SERVICES_DEFINITION;TEST_EXPECTED_SEQUENCE_DEFINITION" \
    "only_pihole_enabled___;pihole;_cli_log_warning|_disk_manifest_mount_all|_disk_initialize_mounts|_configuration_pihole|_docker_compose_command"
}

@parametrize_with_samba() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ENABLED_SERVICES_DEFINITION;TEST_EXPECTED_SEQUENCE_DEFINITION" \
    "only_samba_enabled____;samba;_cli_log_warning|_disk_manifest_mount_all|_disk_initialize_mounts|_configuration_samba|_docker_compose_command"
}

@parametrize_with_syncthing() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ENABLED_SERVICES_DEFINITION;TEST_EXPECTED_SEQUENCE_DEFINITION" \
    "only_syncthing_enabled;syncthing;_cli_log_warning|_disk_manifest_mount_all|_disk_initialize_mounts|_docker_compose_command|_configuration_syncthing"
}

# shellcheck disable=SC2034
test_service_cli_start__@vary__@vary__logs_warning_message() {
  local RPI_SERVICES=()

  stdlib.array.make.from_string RPI_SERVICES "|" "${TEST_ENABLED_SERVICES_DEFINITION}"

  _service_cli_start

  _cli_log_warning.mock.assert_called_once_with \
    "1(Media centre now starting ...)"
}

@parametrize.apply \
  test_service_cli_start__@vary__@vary__logs_warning_message \
  @parametrize_with_all \
  @parametrize_with_samba \
  @parametrize_with_pihole \
  @parametrize_with_syncthing

# shellcheck disable=SC2034
test_service_cli_start__@vary__@vary__mounts_all_disks() {
  local RPI_SERVICES=()

  stdlib.array.make.from_string RPI_SERVICES "|" "${TEST_ENABLED_SERVICES_DEFINITION}"

  _service_cli_start

  _disk_manifest_mount_all.mock.assert_called_once_with ""
}

@parametrize.apply \
  test_service_cli_start__@vary__@vary__mounts_all_disks \
  @parametrize_with_all \
  @parametrize_with_samba \
  @parametrize_with_pihole \
  @parametrize_with_syncthing

# shellcheck disable=SC2034
test_service_cli_start__@vary__@vary__initializes_mounts() {
  local RPI_SERVICES=()

  stdlib.array.make.from_string RPI_SERVICES "|" "${TEST_ENABLED_SERVICES_DEFINITION}"

  _service_cli_start

  _disk_initialize_mounts.mock.assert_called_once_with ""
}

@parametrize.apply \
  test_service_cli_start__@vary__@vary__initializes_mounts \
  @parametrize_with_all \
  @parametrize_with_samba \
  @parametrize_with_pihole \
  @parametrize_with_syncthing

# shellcheck disable=SC2034
test_service_cli_start__@vary_____@vary__configures_pihole() {
  local RPI_SERVICES=()

  stdlib.array.make.from_string RPI_SERVICES "|" "${TEST_ENABLED_SERVICES_DEFINITION}"

  _service_cli_start

  _configuration_pihole.mock.assert_called_once_with ""
}

@parametrize.apply \
  test_service_cli_start__@vary_____@vary__configures_pihole \
  @parametrize_with_all \
  @parametrize_with_pihole

# shellcheck disable=SC2034
test_service_cli_start__@vary__@vary__does_not_configure_pihole() {
  local RPI_SERVICES=()

  stdlib.array.make.from_string RPI_SERVICES "|" "${TEST_ENABLED_SERVICES_DEFINITION}"

  _service_cli_start

  _configuration_pihole.mock.assert_not_called
}

@parametrize.apply \
  test_service_cli_start__@vary__@vary__does_not_configure_pihole \
  @parametrize_with_samba \
  @parametrize_with_syncthing

# shellcheck disable=SC2034
test_service_cli_start__@vary______@vary__configures_samba() {
  local RPI_SERVICES=()

  stdlib.array.make.from_string RPI_SERVICES "|" "${TEST_ENABLED_SERVICES_DEFINITION}"

  _service_cli_start

  _configuration_samba.mock.assert_called_once_with ""
}

@parametrize.apply \
  test_service_cli_start__@vary______@vary__configures_samba \
  @parametrize_with_all \
  @parametrize_with_samba

# shellcheck disable=SC2034
test_service_cli_start__@vary__@vary__does_not_configure_samba() {
  local RPI_SERVICES=()

  stdlib.array.make.from_string RPI_SERVICES "|" "${TEST_ENABLED_SERVICES_DEFINITION}"

  _service_cli_start

  _configuration_samba.mock.assert_not_called
}

@parametrize.apply \
  test_service_cli_start__@vary__@vary__does_not_configure_samba \
  @parametrize_with_pihole \
  @parametrize_with_syncthing

# shellcheck disable=SC2034
test_service_cli_start__@vary__@vary__configures_syncthing() {
  local RPI_SERVICES=()

  stdlib.array.make.from_string RPI_SERVICES "|" "${TEST_ENABLED_SERVICES_DEFINITION}"

  _service_cli_start

  _configuration_syncthing.mock.assert_called_once_with ""
}

@parametrize.apply \
  test_service_cli_start__@vary__@vary__configures_syncthing \
  @parametrize_with_all \
  @parametrize_with_syncthing

# shellcheck disable=SC2034
test_service_cli_start__@vary_____@vary__does_not_configure_syncthing() {
  local RPI_SERVICES=()

  stdlib.array.make.from_string RPI_SERVICES "|" "${TEST_ENABLED_SERVICES_DEFINITION}"

  _service_cli_start

  _configuration_syncthing.mock.assert_not_called
}

@parametrize.apply \
  test_service_cli_start__@vary_____@vary__does_not_configure_syncthing \
  @parametrize_with_pihole \
  @parametrize_with_samba

# shellcheck disable=SC2034
test_service_cli_start__@vary__@vary__calls_dependencies_in_sequence() {
  local RPI_SERVICES=()
  local expected_sequence=()

  stdlib.array.make.from_string RPI_SERVICES "|" "${TEST_ENABLED_SERVICES_DEFINITION}"
  stdlib.array.make.from_string expected_sequence "|" "${TEST_EXPECTED_SEQUENCE_DEFINITION}"
  _mock.sequence.record.start

  _service_cli_start

  _mock.sequence.assert_is \
    "${expected_sequence[@]}"
}

@parametrize.apply \
  test_service_cli_start__@vary__@vary__calls_dependencies_in_sequence \
  @parametrize_with_all \
  @parametrize_with_samba \
  @parametrize_with_pihole \
  @parametrize_with_syncthing
