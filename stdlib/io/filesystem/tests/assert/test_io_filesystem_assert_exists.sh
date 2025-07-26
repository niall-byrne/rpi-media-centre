#!/bin/bash

setup() {
  _mock.create stdlib.io.filesystem.query.exists
  _mock.create stdlib.logger.error
}

test_stdlib_io_filesystem_assert_exists__invalid_args__returns_status_code_126() {
  stdlib.io.filesystem.query.exists.mock.set.rc "126"

  _capture_rc stdlib.io.filesystem.assert.exists

  assert_rc "126"
}

test_stdlib_io_filesystem_assert_exists__invalid_args__logs_an_error() {
  stdlib.io.filesystem.query.exists.mock.set.rc "126"

  stdlib.io.filesystem.assert.exists

  stdlib.logger.error.mock.assert_called_once_with \
    "Invalid arguments provided!"
}

# shellcheck disable=SC2034
test_stdlib_io_filesystem_assert_exists__valid_args____does_not_exist__returns_status_code_1() {
  stdlib.io.filesystem.query.exists.mock.set.rc "1"

  _capture_rc stdlib.io.filesystem.assert.exists "/mock/path"

  assert_rc "1"
}

# shellcheck disable=SC2034
test_stdlib_io_filesystem_assert_exists__valid_args____does_not_exist__logs_an_error() {
  stdlib.io.filesystem.query.exists.mock.set.rc "1"

  stdlib.io.filesystem.assert.exists "/mock/path"

  stdlib.logger.error.mock.assert_called_once_with \
    "The path '/mock/path' does not exist on the filesystem!"
}

test_stdlib_io_filesystem_assert_exists__valid_args____exists__________returns_status_code_0() {
  stdlib.io.filesystem.query.exists.mock.set.rc "0"

  _capture_rc stdlib.io.filesystem.assert.exists "/mock/path"

  assert_rc "0"
}
