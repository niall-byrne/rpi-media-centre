#!/bin/bash

setup() {
  _mock.create _config_pictl_secure_load

  _config_pictl_secure_load.mock.set.keywords "RPI_CONFIGURATION_QUIET_LOAD"
}

test_config_pictl__calls_secure_load_with_correct_args() {
  local RPI_MANIFEST_CONFIG="/mock/path"

  _config_pictl

  _config_pictl_secure_load.mock.assert_called_once_with \
    "1(source) 2(${RPI_MANIFEST_CONFIG}) RPI_CONFIGURATION_QUIET_LOAD(0)"
}
