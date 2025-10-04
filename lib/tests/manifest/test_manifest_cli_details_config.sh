#!/bin/bash

setup() {
  _mock.create _cli_pretty_title
  _mock.create _configuration_pictl_help
}

# shellcheck disable=SC2034
test_manifest_cli_details_config__logs_success_message() {
  local RPI_MANIFEST_CONFIG="/mock/path"

  _manifest_cli_details_config

  _cli_pretty_title.mock.assert_called_once_with \
    "1(** Details for the ${RPI_MANIFEST_CONFIG} file **)"
}

test_manifest_cli_details_config__checks_the_manifest() {
  _manifest_cli_details_config

  _configuration_pictl_help.mock.assert_called_once_with ""
}
