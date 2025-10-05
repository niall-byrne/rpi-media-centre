#!/bin/bash

setup() {
  _mock.create _compile_cli_cli
}

test_pictl_cli__integration__compile_cli__calls_target_function_correctly() {
  _pictl_cli compile cli

  _compile_cli_cli.mock.assert_called_once_with ""
}
