#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
  _mock.create stdlib.security.query.is_root_user
}

test_stdlib_security_assert_is_root_user__invalid_args__returns_status_code_126() {
  stdlib.security.query.is_root_user.mock.set.rc "127"

  _capture.rc stdlib.security.assert.is_root_user

  assert_rc "127"
}

test_stdlib_security_assert_is_root_user__invalid_args__logs_an_error() {
  stdlib.security.query.is_root_user.mock.set.rc "127"

  stdlib.security.assert.is_root_user

  stdlib.logger.error.mock.assert_called_once_with \
    "Invalid arguments provided!"
}

test_stdlib_security_assert_is_root_user__valid_args____euid_not_zero__logs_error_messages() {
  stdlib.security.query.is_root_user.mock.set.rc 1

  stdlib.security.assert.is_root_user

  stdlib.logger.error.mock.assert_called_once_with \
    "SECURITY: This script must be run as root."
}

test_stdlib_security_assert_is_root_user__valid_args____euid_not_zero__returns_status_code_1() {
  stdlib.security.query.is_root_user.mock.set.rc 1

  _capture.rc stdlib.security.assert.is_root_user

  assert_rc "1"
}

test_stdlib_security_assert_is_root_user__valid_args____euid_zero______returns_status_code_0() {
  stdlib.security.query.is_root_user.mock.set.rc 0

  _capture.rc stdlib.security.assert.is_root_user

  assert_rc "0"
}
