#!/bin/bash

setup() {
  _mock.create stdlib.io.filesystem.query.is_file
  _mock.create stdlib.logger.error
}

test_stdlib_io_filesystem_assert_is_file__invalid_args__returns_status_code_126() {
  stdlib.io.filesystem.query.is_file.mock.set.rc "126"

  _capture_rc stdlib.io.filesystem.assert.is_file

  assert_rc "126"
}

test_stdlib_io_filesystem_assert_is_file__invalid_args__logs_an_error() {
  stdlib.io.filesystem.query.is_file.mock.set.rc "126"

  stdlib.io.filesystem.assert.is_file

  stdlib.logger.error.mock.assert_called_once_with \
    "Invalid arguments provided!"
}

# shellcheck disable=SC2034
test_stdlib_io_filesystem_assert_is_file__valid_args____is_not_file__returns_status_code_1() {
  stdlib.io.filesystem.query.is_file.mock.set.rc "1"

  _capture_rc stdlib.io.filesystem.assert.is_file "/mock/path"

  assert_rc "1"
}

# shellcheck disable=SC2034
test_stdlib_io_filesystem_assert_is_file__valid_args____is_not_file__logs_an_error() {
  stdlib.io.filesystem.query.is_file.mock.set.rc "1"

  stdlib.io.filesystem.assert.is_file "/mock/path"

  stdlib.logger.error.mock.assert_called_once_with \
    "The path '/mock/path' is not a valid filesystem file!"
}

test_stdlib_io_filesystem_assert_is_file__valid_args____is_file______returns_status_code_0() {
  stdlib.io.filesystem.query.is_file.mock.set.rc "0"

  _capture_rc stdlib.io.filesystem.assert.is_file "/mock/path"

  assert_rc "0"
}
