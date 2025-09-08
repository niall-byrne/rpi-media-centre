#!/bin/bash

setup() {
  _mock.create _configuration_pictl_check
  _mock.create _cli_log_success
}

test_manifest_cli_check_config__checks_the_manifest() {
  _manifest_cli_check_config

  _configuration_pictl_check.mock.assert_called_once_with ""
}

test_manifest_cli_check_config__logs_success_message() {
  _manifest_cli_check_config

  _cli_log_success.mock.assert_called_once_with \
    "1(The rpi-media-centre configuration manifest file has no syntax errors!)"
}
