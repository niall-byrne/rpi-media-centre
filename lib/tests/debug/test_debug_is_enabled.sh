#!/bin/bash

test_debug_is_enabled__enabled__returns_expected_status_code() {
  # shellcheck disable=SC2034
  local RPI_DEBUG=1

  _capture.rc _debug_is_enabled

  assert_rc "0"
}

test_debug_is_enabled__disabled__returns_expected_status_code() {
  # shellcheck disable=SC2034
  local RPI_DEBUG=""

  _capture.rc _debug_is_enabled

  assert_rc "1"
}
