#!/bin/bash

setup() {
  _mock.create _compile_cli_completion
}

test_pictl_cli__integration__compile_completion__calls_target_function_correctly() {
  _pictl_cli compile completion

  _compile_cli_completion.mock.assert_called_once_with ""
}
