#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/disk/tests/__fakes__/crypt_data.sh"

_fixture__3_disks__3_crypt_groups() {
  # shellcheck disable=SC2034
  RPI_DISK_CRYPT_PASSWORD_SET=($'\\0' $'\\0' $'\\0')
  # shellcheck disable=SC2034
  RPI_DISK_CRYPT_GROUP_SET=("group1" "group2" "group3")
}

_scenario__3_disks__3_crypt_groups__3_entered_passwords() {
  _create_fake_disk_with_crypt_group "1" "group1"
  _io_prompt.mock.set.subcommand 'RPI_DISK_CRYPT_PASSWORD="password1"'
  _disk_unlock_with_crypt_group

  _create_fake_disk_with_crypt_group "2" "group2"
  _io_prompt.mock.set.subcommand 'RPI_DISK_CRYPT_PASSWORD="password2"'
  _disk_unlock_with_crypt_group

  _create_fake_disk_with_crypt_group "3" "group3"
  _io_prompt.mock.set.subcommand 'RPI_DISK_CRYPT_PASSWORD="password3"'
  _disk_unlock_with_crypt_group
}

_fixture__3_disks__2_crypt_groups() {
  # shellcheck disable=SC2034
  RPI_DISK_CRYPT_PASSWORD_SET=($'\\0' $'\\0' $'\\0')
  # shellcheck disable=SC2034
  RPI_DISK_CRYPT_GROUP_SET=("group1" "group2" "group2")
}

_scenario__3_disks__2_crypt_groups__2_entered_passwords() {

  _create_fake_disk_with_crypt_group "1" "group1"
  _io_prompt.mock.set.subcommand 'RPI_DISK_CRYPT_PASSWORD="password1"'
  _disk_unlock_with_crypt_group

  _create_fake_disk_with_crypt_group "2" "group2"
  _io_prompt.mock.set.subcommand 'RPI_DISK_CRYPT_PASSWORD="password2"'
  _disk_unlock_with_crypt_group

  _create_fake_disk_with_crypt_group "3" "group2"
  _io_prompt.mock.set.subcommand 'RPI_DISK_CRYPT_PASSWORD="password3"'
  _disk_unlock_with_crypt_group
}

_fixture__3_disks__1_crypt_groups() {
  # shellcheck disable=SC2034
  RPI_DISK_CRYPT_PASSWORD_SET=($'\\0' $'\\0' $'\\0')
  # shellcheck disable=SC2034
  RPI_DISK_CRYPT_GROUP_SET=("group1" "group1" "group1")
}

_scenario__3_disks__1_crypt_groups__1_entered_passwords() {
  _create_fake_disk_with_crypt_group "1" "group1"
  _io_prompt.mock.set.subcommand 'RPI_DISK_CRYPT_PASSWORD="password1"'
  _disk_unlock_with_crypt_group

  _create_fake_disk_with_crypt_group "2" "group1"
  _io_prompt.mock.set.subcommand 'RPI_DISK_CRYPT_PASSWORD="password2"'
  _disk_unlock_with_crypt_group

  _create_fake_disk_with_crypt_group "3" "group1"
  _io_prompt.mock.set.subcommand 'RPI_DISK_CRYPT_PASSWORD="password3"'
  _disk_unlock_with_crypt_group
}
