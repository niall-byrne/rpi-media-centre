#!/bin/bash

setup() {
  _mock.create _configuration_pictl_secure_load

  _configuration_pictl_secure_load.mock.set.keywords "RPI_CONFIGURATION_QUIET_LOAD"
}

test_configuration_pictl_check__calls_secure_load_with_correct_args() {
  local expected_command

  expected_command="
  source /etc/rpi/config &&
  declare -p | \
      grep '^declare -. RPI_' |
      sed 's/^declare -. //g' |
      sed 's/=.*//g' |
      sort
"

  _configuration_pictl_check

  _configuration_pictl_secure_load.mock.assert_called_once_with \
    "1(env) 2(-i) 3(bash) 4(-c) 5(${expected_command}) RPI_CONFIGURATION_QUIET_LOAD(1)"
}
