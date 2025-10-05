#!/bin/bash

setup() {
  _mock.create _service_cli_resume
}

test_pictl_cli__integration__service_resume__calls_target_function_correctly() {
  _pictl_cli service resume

  _service_cli_resume.mock.assert_called_once_with ""
}

