#!/bin/bash

setup() {
  _mock.create _debug_is_enabled
  _mock.create test_mock
}

test_debug_with__debug_enabled___executes_arguments() {
  _debug_is_enabled.mock.set.rc 0

  _debug_with test_mock

  test_mock.mock.assert_called_once_with ""
}

test_debug_with__debug_disabled__does_not_execute_arguments() {
  _debug_is_enabled.mock.set.rc 1

  _debug_with test_mock

  test_mock.mock.assert_not_called
}
