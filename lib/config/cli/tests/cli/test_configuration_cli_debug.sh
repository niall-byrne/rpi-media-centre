#!/bin/bash

setup() {
  _mock.create _config_pictl_debug
}

test_config_cli_debug__debugs_the_config() {
  _config_cli_debug

  _config_pictl_debug.mock.assert_called_once_with ""
}
