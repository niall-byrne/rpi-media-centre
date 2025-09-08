#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/disk/tests/disk/__fixtures__/disk_initialize_mounts.sh"

setup_suite() {
  _fixture_escape_rpi_vars
}

setup() {
  _fixture_disk_initialize_mounts
}

test_disk_initialize_mounts__pihole___calls_stdlib_security_path_make_dir() {
  # shellcheck disable=SC2034
  RPI_SERVICES=("pihole")

  _disk_initialize_mounts

  stdlib.security.path.make.dir.mock.assert_count_is "2"
  assert_equals \
    "$(_fixture_disk_initialize_mounts__pihole__calls)" \
    "$(stdlib.security.path.make.dir.mock.get.calls)"
}

test_disk_initialize_mounts__plex___calls_stdlib_security_path_make_dir() {
  # shellcheck disable=SC2034
  RPI_SERVICES=("plex")

  _disk_initialize_mounts

  stdlib.security.path.make.dir.mock.assert_count_is "3"
  assert_equals \
    "$(_fixture_disk_initialize_mounts__plex__calls)" \
    "$(stdlib.security.path.make.dir.mock.get.calls)"
}

test_disk_initialize_mounts__samba__calls_stdlib_security_path_make_dir() {
  # shellcheck disable=SC2034
  RPI_SERVICES=("samba")

  _disk_initialize_mounts

  stdlib.security.path.make.dir.mock.assert_count_is "5"
  assert_equals \
    "$(_fixture_disk_initialize_mounts__samba__calls)" \
    "$(stdlib.security.path.make.dir.mock.get.calls)"
}

test_disk_initialize_mounts__syncthing__calls_stdlib_security_path_make_dir() {
  # shellcheck disable=SC2034
  RPI_SERVICES=("syncthing")

  _disk_initialize_mounts

  stdlib.security.path.make.dir.mock.assert_count_is "2"
  assert_equals \
    "$(_fixture_disk_initialize_mounts__syncthing__calls)" \
    "$(stdlib.security.path.make.dir.mock.get.calls)"
}

test_disk_initialize_mounts__all__calls_stdlib_security_path_make_dir() {
  # shellcheck disable=SC2034
  RPI_SERVICES=("plex" "samba" "syncthing")

  _disk_initialize_mounts

  stdlib.security.path.make.dir.mock.assert_count_is "10"
  assert_equals \
    "$(_fixture_disk_initialize_mounts__plex__calls)
$(_fixture_disk_initialize_mounts__samba__calls)
$(_fixture_disk_initialize_mounts__syncthing__calls)" \
    "$(stdlib.security.path.make.dir.mock.get.calls)"
}
