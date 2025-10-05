#!/bin/bash

setup() {
  _mock.create _service_cli_stop
}

test_pictl_cli__integration__service_stop__calls_target_function_correctly() {
  _pictl_cli service stop

  _service_cli_stop.mock.assert_called_once_with ""
}

