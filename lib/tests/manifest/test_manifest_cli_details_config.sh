#!/bin/bash

setup() {
  _mock.create _cli_pretty_title
  _mock.create _configuration_pictl_help
}

# shellcheck disable=SC2034
test_manifest_cli_details_config__logs_success_message() {
  _manifest_cli_details_config

  _cli_pretty_title.mock.assert_called_once_with \
    "1(** Details for the /etc/rpi/config file **)"
}

test_manifest_cli_details_config__checks_the_manifest() {
  _manifest_cli_details_config

  _configuration_pictl_help.mock.assert_called_once_with ""
}
