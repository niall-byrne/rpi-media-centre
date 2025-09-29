#!/bin/bash

setup() {
  _mock.create _backup_scheduler_validation
}

test_configuration_pictl_validation_backup__calls_validation() {
  _configuration_pictl_validation_backup

  _backup_scheduler_validation.mock.assert_called_once_with ""
}
