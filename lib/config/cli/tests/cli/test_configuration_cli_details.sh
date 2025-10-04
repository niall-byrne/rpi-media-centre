#!/bin/bash

setup() {
  _mock.create _cli_pretty_title
  _mock.create _config_pictl_help
}

# shellcheck disable=SC2034
test_config_cli_details__logs_success_message() {
  local RPI_MANIFEST_CONFIG="/mock/path"

  _config_cli_details

  _cli_pretty_title.mock.assert_called_once_with \
    "1(** Details for the ${RPI_MANIFEST_CONFIG} file **)"
}

test_config_cli_details__prints_the_help_message() {
  _config_cli_details

  _config_pictl_help.mock.assert_called_once_with ""
}
