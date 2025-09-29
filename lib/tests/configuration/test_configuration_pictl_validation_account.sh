#!/bin/bash

setup() {
  _mock.create _security_defaults_set
  _mock.create _security_warning_single_user_mode
}

test_configuration_pictl_validation_account__calls_security_defaults_set() {
  _configuration_pictl_validation_account

  _security_defaults_set.mock.assert_called_once_with ""
}

test_configuration_pictl_validation_account__calls_security_warning_single_user_mode() {
  _configuration_pictl_validation_account

  _security_warning_single_user_mode.mock.assert_called_once_with ""
}
