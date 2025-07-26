#!/bin/bash

setup() {
  _mock.create stdlib.io.filesystem.query.is_folder
  _mock.create stdlib.logger.error
}

test_stdlib_io_filesystem_assert_is_folder__invalid_args___returns_status_code_126() {
  stdlib.io.filesystem.query.is_folder.mock.set.rc "126"

  _capture_rc stdlib.io.filesystem.assert.is_folder

  assert_rc "126"
}

test_stdlib_io_filesystem_assert_is_folder__invalid_args___logs_an_error() {
  stdlib.io.filesystem.query.is_folder.mock.set.rc "126"

  stdlib.io.filesystem.assert.is_folder

  stdlib.logger.error.mock.assert_called_once_with \
    "Invalid arguments provided!"
}

# shellcheck disable=SC2034
test_stdlib_io_filesystem_assert_is_folder__is_not_folder__returns_status_code_1() {
  stdlib.io.filesystem.query.is_folder.mock.set.rc "1"

  _capture_rc stdlib.io.filesystem.assert.is_folder "/mock/path"

  assert_rc "1"
}

# shellcheck disable=SC2034
test_stdlib_io_filesystem_assert_is_folder__is_not_folder__logs_an_error() {
  stdlib.io.filesystem.query.is_folder.mock.set.rc "1"

  stdlib.io.filesystem.assert.is_folder "/mock/path"

  stdlib.logger.error.mock.assert_called_once_with \
    "The path '/mock/path' is not a valid filesystem folder!"
}

test_stdlib_io_filesystem_assert_is_folder__is_folder______returns_status_code_0() {
  stdlib.io.filesystem.query.is_folder.mock.set.rc "0"

  _capture_rc stdlib.io.filesystem.assert.is_folder "/mock/path"

  assert_rc "0"
}
