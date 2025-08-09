#!/bin/bash

load "${RPI_WORKING_DIRECTORY}/lib/disk/tests/disk/__fixtures__/disk_initialize_mounts.sh"

setup_suite() {
  _fixture_escape_rpi_vars
}

setup() {
  _fixture_disk_initialize_mounts
}

test_disk_initialize_mounts__plex___calls_security_path_mkdir() {
  # shellcheck disable=SC2034
  RPI_SERVICES=("plex")

  _disk_initialize_mounts

  assert_equals "3" "$(_security_path_mkdir.mock.get.count)"
  assert_equals \
    "$(_fixture_disk_initialize_mounts__plex__calls)" \
    "$(_security_path_mkdir.mock.get.calls)"
}

test_disk_initialize_mounts__samba__calls_security_path_mkdir() {
  # shellcheck disable=SC2034
  RPI_SERVICES=("samba")

  _disk_initialize_mounts

  assert_equals "5" "$(_security_path_mkdir.mock.get.count)"
  assert_equals \
    "$(_fixture_disk_initialize_mounts__samba__calls)" \
    "$(_security_path_mkdir.mock.get.calls)"
}

test_disk_initialize_mounts__syncthing__calls_security_path_mkdir() {
  # shellcheck disable=SC2034
  RPI_SERVICES=("syncthing")

  _disk_initialize_mounts

  assert_equals "2" "$(_security_path_mkdir.mock.get.count)"
  assert_equals \
    "$(_fixture_disk_initialize_mounts__syncthing__calls)" \
    "$(_security_path_mkdir.mock.get.calls)"
}

test_disk_initialize_mounts__all__calls_security_path_mkdir() {
  # shellcheck disable=SC2034
  RPI_SERVICES=("plex" "samba" "syncthing")

  _disk_initialize_mounts

  assert_equals "10" "$(_security_path_mkdir.mock.get.count)"
  assert_equals \
    "$(_fixture_disk_initialize_mounts__plex__calls)
$(_fixture_disk_initialize_mounts__samba__calls)
$(_fixture_disk_initialize_mounts__syncthing__calls)" \
    "$(_security_path_mkdir.mock.get.calls)"
}
