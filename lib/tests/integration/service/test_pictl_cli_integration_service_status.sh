#!/bin/bash

setup() {
  _mock.create _service_cli_status
}

test_pictl_cli__integration__service_status__calls_target_function_correctly() {
  _pictl_cli service status

  _service_cli_status.mock.assert_called_once_with ""
}
