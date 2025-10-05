#!/bin/bash

setup() {
  _mock.create _service_cli_kill
}

test_pictl_cli__integration__service_kill__calls_target_function_correctly() {
  _pictl_cli service kill

  _service_cli_kill.mock.assert_called_once_with ""
}
