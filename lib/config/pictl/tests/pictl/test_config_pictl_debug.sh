#!/bin/bash

setup() {
  _mock.create _cli_pretty_title
  _mock.create _cli_pretty_highlight
  _mock.create _cli_pretty_env_var_pipe

  _cli_pretty_env_var_pipe.mock.set.pipeable 1
}

test_config_pictl_debug__calls_title() {
  _config_pictl_debug > /dev/null

  _cli_pretty_title.mock.assert_called_once_with \
    "1(-- rpi-media-centre running config --)"
}

test_config_pictl_debug__calls_highlight() {
  _config_pictl_debug > /dev/null

  _cli_pretty_highlight.mock.assert_called_once_with \
    "1(** credentials have been removed **)"
}

# shellcheck disable=SC2034
test_config_pictl_debug__pipes_correct_output_to_pretty_env_var() {
  TEST_OUTPUT="$(
    local variable

    for variable in $(declare -p | awk '{ print $3 }' | cut -d '=' -f1 | grep "^RPI"); do
      unset "${variable}"
    done

    export RPI_EXPORT_VARIABLE_1="export_value1"
    export RPI_EXPORT_VARIABLE_2="export_value2"
    export RPI_EXPORT_ARRAY=("1" "2" "3")
    export RPI_EXPORT_CREDENTIALS_VARIABLE_1="secret1"
    export RPI_EXPORT_CREDENTIALS_VARIABLE_2="secret2"

    local RPI_LOCAL_VARIABLE_1="value1"
    local RPI_LOCAL_VARIABLE_2="value2"
    local RPI_LOCAL_ARRAY=("4" "5" "6")
    local RPI_LOCAL_CREDENTIALS_VARIABLE_1="secret1"
    local RPI_LOCAL_CREDENTIALS_VARIABLE_2="secret2"

    _config_pictl_debug
  )"

  _cli_pretty_env_var_pipe.mock.assert_calls_are \
    '1(RPI_CONFIGURATION_QUIET_LOAD="1"
RPI_EXPORT_ARRAY=([0]="1" [1]="2" [2]="3")
RPI_EXPORT_VARIABLE_1="export_value1"
RPI_EXPORT_VARIABLE_2="export_value2"
RPI_LOCAL_ARRAY=([0]="4" [1]="5" [2]="6")
RPI_LOCAL_VARIABLE_1="value1"
RPI_LOCAL_VARIABLE_2="value2")'
}
