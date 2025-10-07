#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/install/installer.sh"

setup_suite() {
  temp_folder="$(mktemp -d)"
}

setup() {
  _mock.create _cli_log_warning
  _mock.create _cli_log_success
  _mock.create stdlib.security.path.secure

  cd "${RPI_WORKING_DIRECTORY}" || return 127
}

teardown_suite() {
  rm -r "${temp_folder}"
}

@parametrize_with_constants() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_REPOSITORY_LOCATION" \
    "scenario1;/test/repository"
}

_fixture_get_expected_shim_content() {
  (
    export RPI_REPOSITORY_LOCATION

    # shellcheck disable=SC2016
    envsubst '${RPI_REPOSITORY_LOCATION}' < "services/cli/shim.sh"
  )
}

# shellcheck disable=SC2034
test_install_installer_service_shim__@vary__logs_warning_message() {
  local RPI_INSTALLER_SHIM_PATH="${temp_folder}/shim"
  local RPI_REPOSITORY_LOCATION="${TEST_REPOSITORY_LOCATION}"

  _installer_service_shim

  _cli_log_warning.mock.assert_called_once_with \
    "1(INSTALLER: Installing service shim ...)"
}

@parametrize_with_constants \
  test_install_installer_service_shim__@vary__logs_warning_message

# shellcheck disable=SC2034
test_install_installer_service_shim__@vary__creates_shim_file_with_correct_content() {
  local RPI_INSTALLER_SHIM_PATH="${temp_folder}/shim"
  local RPI_REPOSITORY_LOCATION="${TEST_REPOSITORY_LOCATION}"

  _installer_service_shim

  TEST_OUTPUT="$(_fixture_get_expected_shim_content)"
  assert_snapshot "${RPI_INSTALLER_SHIM_PATH}"
}

@parametrize_with_constants \
  test_install_installer_service_shim__@vary__creates_shim_file_with_correct_content

# shellcheck disable=SC2034
test_install_installer_service_shim__@vary__secures_shim_file() {
  local RPI_INSTALLER_SHIM_PATH="${temp_folder}/shim"
  local RPI_REPOSITORY_LOCATION="${TEST_REPOSITORY_LOCATION}"

  _installer_service_shim

  stdlib.security.path.secure.mock.assert_called_once_with \
    "1(${temp_folder}/shim) 2(root) 3(root) 4(755)"
}

@parametrize_with_constants \
  test_install_installer_service_shim__@vary__secures_shim_file

# shellcheck disable=SC2034
test_install_installer_service_shim__@vary__logs_success_message() {
  local RPI_INSTALLER_SHIM_PATH="${temp_folder}/shim"
  local RPI_REPOSITORY_LOCATION="${TEST_REPOSITORY_LOCATION}"

  _installer_service_shim

  _cli_log_success.mock.assert_called_once_with \
    "1(INSTALLER: Service shim installed!)"
}

@parametrize_with_constants \
  test_install_installer_service_shim__@vary__logs_success_message
