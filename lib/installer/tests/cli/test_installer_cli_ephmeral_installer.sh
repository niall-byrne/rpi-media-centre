#!/bin/bash

TEMP_FILE="/dev/stdout"

setup() {
  _mock.create stdlib.security.path.secure
  _mock.create source
  _mock.create _mocked_piped_reader
  _mocked_piped_reader.mock.set.pipeable "1"

  _mock.create mktemp
  mktemp.mock.set.stdout "${TEMP_FILE}"
}

_parameterize_with_branches() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TARGET_BRANCH" \
    "origin/dev_;origin/dev" \
    "origin/main;origin/main"
}

test_installer_cli_ephemeral_installer__@vary__calls_mktemp() {
  _capture.output _installer_cli_ephemeral_installer "${TARGET_BRANCH}"

  mktemp.mock.assert_called_once_with ""
}

_parameterize_with_branches \
  "test_installer_cli_ephemeral_installer__@vary__calls_mktemp"

test_installer_cli_ephemeral_installer__@vary__calls_stdlib_security_path_secure() {
  _capture.output _installer_cli_ephemeral_installer "${TARGET_BRANCH}"

  stdlib.security.path.secure.mock.assert_called_once_with \
    "1(${TEMP_FILE}) 2(root) 3(root) 4(700)"
}

_parameterize_with_branches \
  "test_installer_cli_ephemeral_installer__@vary__calls_stdlib_security_path_secure"

test_installer_cli_ephemeral_installer__@vary__creates_ephemeral_installer() {
  TEST_EXPECTED="$(cat "${RPI_WORKING_DIRECTORY}/lib/installer/installer.sh")"$'\n'
  TEST_EXPECTED+="_installer ${TARGET_BRANCH}"$'\n'

  _capture.output_raw _installer_cli_ephemeral_installer "${TARGET_BRANCH}"

  assert_output "${TEST_EXPECTED}"
}

_parameterize_with_branches \
  "test_installer_cli_ephemeral_installer__@vary__creates_ephemeral_installer"

test_installer_cli_ephemeral_installer__@vary__sources_ephemeral_installer() {
  _capture.output _installer_cli_ephemeral_installer "${TARGET_BRANCH}"

  source.mock.assert_called_once_with "1(${TEMP_FILE})"
}

_parameterize_with_branches \
  "test_installer_cli_ephemeral_installer__@vary__sources_ephemeral_installer"
