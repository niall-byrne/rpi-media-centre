#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
  _mock.create stdlib.security.user.query.is_root
}

test_stdlib_security_user_assert_is_root__invalid_args__returns_status_code_126() {
  stdlib.security.user.query.is_root.mock.set.rc "127"

  _capture.rc stdlib.security.user.assert.is_root

  assert_rc "127"
}

test_stdlib_security_user_assert_is_root__invalid_args__logs_an_error() {
  stdlib.security.user.query.is_root.mock.set.rc "127"

  stdlib.security.user.assert.is_root

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.message.get ARGUMENTS_INVALID))"
}

test_stdlib_security_user_assert_is_root__valid_args____euid_not_zero__logs_error_messages() {
  stdlib.security.user.query.is_root.mock.set.rc 1

  stdlib.security.user.assert.is_root

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.message.get SECURITY_MUST_BE_RUN_AS_ROOT))"
}

test_stdlib_security_user_assert_is_root__valid_args____euid_not_zero__returns_status_code_1() {
  stdlib.security.user.query.is_root.mock.set.rc 1

  _capture.rc stdlib.security.user.assert.is_root

  assert_rc "1"
}

test_stdlib_security_user_assert_is_root__valid_args____euid_zero______returns_status_code_0() {
  stdlib.security.user.query.is_root.mock.set.rc 0

  _capture.rc stdlib.security.user.assert.is_root

  assert_rc "0"
}
