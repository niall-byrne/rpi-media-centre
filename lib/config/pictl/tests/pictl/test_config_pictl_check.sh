#!/bin/bash

setup() {
  _mock.create _config_pictl_secure_load

  _config_pictl_secure_load.mock.set.keywords "RPI_CONFIGURATION_QUIET_LOAD"
}

test_config_pictl_check__calls_secure_load_with_correct_args() {
  local expected_command

  expected_command="
  source ${RPI_MANIFEST_CONFIG} &&
  declare -p | \
      grep '^declare -. RPI_' |
      sed 's/^declare -. //g' |
      sed 's/=.*//g' |
      sort
"

  _config_pictl_check

  _config_pictl_secure_load.mock.assert_called_once_with \
    "1(env) 2(-i) 3(bash) 4(-c) 5(${expected_command}) RPI_CONFIGURATION_QUIET_LOAD(1)"
}
