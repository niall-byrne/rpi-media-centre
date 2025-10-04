#!/bin/bash

setup() {
  _mock.create _config_pictl_check
  _mock.create _cli_log_success
}

test_config_cli_check__checks_the_config() {
  _config_cli_check

  _config_pictl_check.mock.assert_called_once_with ""
}

test_config_cli_check__logs_success_message() {
  _config_cli_check

  _cli_log_success.mock.assert_called_once_with \
    "1(The rpi-media-centre config file has no syntax errors!)"
}
