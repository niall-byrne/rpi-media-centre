#!/bin/bash

setup() {
  _mock.create _service_cli_pause
}

test_pictl_cli__integration__service_pause__calls_target_function_correctly() {
  _pictl_cli service pause

  _service_cli_pause.mock.assert_called_once_with ""
}
