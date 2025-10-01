#!/bin/bash

# pictl configuration validation library

set -eo pipefail

RPI_CONFIGURATION_VALIDATORS_ALL_ARRAY=("account" "backup" "security")
RPI_CONFIGURATION_VALIDATORS_DISABLED_ARRAY=""

_configuration_pictl_validation() {
  # shellcheck disable=SC2034
  local configuration_disabled_validators=("${RPI_CONFIGURATION_VALIDATORS_DISABLED_ARRAY[@]}")
  local configuration_validator
  local configuration_validators=("${RPI_CONFIGURATION_VALIDATORS_ALL_ARRAY[@]}")

  for configuration_validator in "${configuration_validators[@]}"; do
    if ! stdlib.array.query.is_contains "${configuration_validator}" configuration_disabled_validators; then
      "_configuration_pictl_validation_${configuration_validator}"
    fi
  done
}

_configuration_pictl_validation_account() {
  _security_defaults_set
  _security_warning_single_user_mode
}

_configuration_pictl_validation_backup() {
  _backup_scheduler_validation
}

_configuration_pictl_validation_security() {
  _security_validation
}
