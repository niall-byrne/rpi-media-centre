#!/bin/bash

setup() {
  _mock.create _service_cli_logs
}

test_pictl_cli__integration__service_logs__calls_target_function_correctly() {
  _pictl_cli service logs

  _service_cli_logs.mock.assert_called_once_with ""
}
