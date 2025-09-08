#!/bin/bash

test_service_query_is_selected__is_selected______return_status_code_0() {
  # shellcheck disable=SC2034
  local RPI_SERVICES=("mock_service_1")

  _capture.rc _service_query_is_selected "mock_service_1"

  assert_rc "0"
}

test_service_query_is_selected__is_not_selected__return_status_code_0() {
  # shellcheck disable=SC2034
  local RPI_SERVICES=("mock_service_1")

  _capture.rc _service_query_is_selected "mock_service_2"

  assert_rc "1"
}
