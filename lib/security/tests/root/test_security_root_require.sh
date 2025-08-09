#!/bin/bash

setup() {
  _fixture_mock_logs
  _mock.create __security_root_read_euid
}

test_security_root_require__euid_not_zero__logs_error_messages() {
  local _RPI_SECURITY_EUID=1000

  _security_root_require

  _cli_log_error.mock.assert_called_once_with \
    "SECURITY: This script must be run as root."
}

test_security_root_require__euid_not_zero__returns_status_code_127() {
  local _RPI_SECURITY_EUID=1000

  _capture.rc _security_root_require

  assert_rc "127"
}

test_security_root_require__euid_zero______sudo_user_not_set__username_not_set__logs_error_messages() {
  local _RPI_SECURITY_EUID=0
  local SUDO_USER=""
  RPI_SVC_USERNAME=""

  _security_root_require

  _cli_log_error.mock.assert_called_once_with \
    "SECURITY: pictl cannot be used as a root process."
  _cli_log_info.mock.assert_called_once_with \
    "Please consider using an administrative user with 'sudo'."
}

test_security_root_require__euid_zero______sudo_user_not_set__username_not_set__returns_status_code_127() {
  local _RPI_SECURITY_EUID=0
  local SUDO_USER=""
  RPI_SVC_USERNAME=""

  _capture.rc _security_root_require

  assert_rc "127"
}

test_security_root_require__euid_zero______sudo_user_set______username_not_set__returns_status_code_0() {
  local _RPI_SECURITY_EUID=0
  # shellcheck disable=SC2034
  RPI_SVC_USERNAME=""
  # shellcheck disable=SC2034
  local SUDO_USER="user_with_sudo"

  _capture.rc _security_root_require

  assert_rc "0"
}

test_security_root_require__euid_zero______sudo_user_not_set__username_set______returns_status_code_0() {
  local _RPI_SECURITY_EUID=0
  # shellcheck disable=SC2034
  RPI_SVC_USERNAME="specified_user"
  # shellcheck disable=SC2034
  local SUDO_USER=""

  _capture.rc _security_root_require

  assert_rc "0"
}
