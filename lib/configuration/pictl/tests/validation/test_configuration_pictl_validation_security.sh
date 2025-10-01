#!/bin/bash

setup() {
  _mock.create _security_validation
}

test_configuration_pictl_validation_security__calls_security_defaults_set() {
  _configuration_pictl_validation_security

  _security_validation.mock.assert_called_once_with ""
}
