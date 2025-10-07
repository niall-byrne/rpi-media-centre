#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/install/installer.sh"

setup() {
  _mock.create _installer_service_repository
  _mock.create _installer_service_shim
  _mock.create _installer_service_backup
}

@parametrize_with_installer_args() {
  # $1: the function being tested

  @parametrize \
    "${1}" \
    "TEST_ARG;TEST_EXPECTED_CALL" \
    "with_sha___;some_sha;some_sha" \
    "with_no_arg;;;"
}

test_install_installer__@vary__calls_repository_installer() {
  _installer "${TEST_ARG}"

  _installer_service_repository.mock.assert_called_once_with \
    "1(${TEST_EXPECTED_CALL})"
}

@parametrize_with_installer_args \
  test_install_installer__@vary__calls_repository_installer

test_install_installer__@vary__calls_shim_installer() {
  _installer "${TEST_ARG}"

  _installer_service_shim.mock.assert_called_once_with ""
}

@parametrize_with_installer_args \
  test_install_installer__@vary__calls_shim_installer

test_install_installer__@vary__calls_backup_installer() {
  _installer "${TEST_ARG}"

  _installer_service_backup.mock.assert_called_once_with ""
}

@parametrize_with_installer_args \
  test_install_installer__@vary__calls_backup_installer

test_install_installer__@vary__calls_functions_in_correct_order() {
  _mock.sequence.record.start

  _installer "${TEST_ARG}"

  _mock.sequence.assert_is \
    "_installer_service_repository" \
    "_installer_service_shim" \
    "_installer_service_backup"
}

@parametrize_with_installer_args \
  test_install_installer__@vary__calls_functions_in_correct_order
