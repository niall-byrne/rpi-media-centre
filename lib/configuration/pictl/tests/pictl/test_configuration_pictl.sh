#!/bin/bash

setup() {
  _mock.create _configuration_pictl_secure_load

  _configuration_pictl_secure_load.mock.set.keywords "RPI_CONFIGURATION_QUIET_LOAD"
}

test_configuration_pictl__calls_secure_load_with_correct_args() {
  _configuration_pictl

  _configuration_pictl_secure_load.mock.assert_called_once_with \
    "1(source) 2(/etc/rpi/config) RPI_CONFIGURATION_QUIET_LOAD(0)"
}
