#!/bin/bash

setup() {
  _fixture_mock_logs
  _mock.create stdlib.security.user.assert.is_root
}

test_security_root_require__user_not_root__calls_stdlib_security_assert_is_root_user() {
  stdlib.security.user.assert.is_root.mock.set.rc 1

  _capture.rc _security_root_require

  stdlib.security.user.assert.is_root.mock.assert_called_once_with ""
}

test_security_root_require__user_not_root__returns_status_code_127() {
  stdlib.security.user.assert.is_root.mock.set.rc 1

  _capture.rc _security_root_require

  assert_rc "127"
}

test_security_root_require__user_is_root___calls_stdlib_security_assert_is_root_user() {
  stdlib.security.user.assert.is_root.mock.set.rc 0

  _capture.rc _security_root_require

  stdlib.security.user.assert.is_root.mock.assert_called_once_with ""
}

test_security_root_require__user_is_root___sudo_user_not_set__username_not_set__logs_error_messages() {
  local SUDO_USER=""
  RPI_SVC_USERNAME=""

  _security_root_require

  _cli_log_error.mock.assert_called_once_with \
    "1(SECURITY: pictl cannot be used as a root process.)"
  _cli_log_info.mock.assert_called_once_with \
    "1(Please consider using an administrative user with 'sudo'.)"
}

test_security_root_require__user_is_root___sudo_user_not_set__username_not_set__returns_status_code_127() {
  local SUDO_USER=""
  RPI_SVC_USERNAME=""

  _capture.rc _security_root_require

  assert_rc "127"
}

test_security_root_require__user_is_root___sudo_user_set______username_not_set__returns_status_code_0() {
  # shellcheck disable=SC2034
  RPI_SVC_USERNAME=""
  # shellcheck disable=SC2034
  local SUDO_USER="user_with_sudo"

  _capture.rc _security_root_require

  assert_rc "0"
}

test_security_root_require__user_is_root___sudo_user_not_set__username_set______returns_status_code_0() {
  # shellcheck disable=SC2034
  RPI_SVC_USERNAME="specified_user"
  # shellcheck disable=SC2034
  local SUDO_USER=""

  _capture.rc _security_root_require

  assert_rc "0"
}
