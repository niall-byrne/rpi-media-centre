#!/bin/bash

setup() {
  _mock.create _service_cli_start
}

test_pictl_cli__integration__service_start__calls_target_function_correctly() {
  _pictl_cli service start

  _service_cli_start.mock.assert_called_once_with ""
}
