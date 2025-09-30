#!/bin/bash

# pictl config validation library

set -eo pipefail

RPI_CONFIGURATION_VALIDATORS_ALL_ARRAY=("account" "backup" "security")
RPI_CONFIGURATION_VALIDATORS_DISABLED_ARRAY=""

_config_pictl_validation() {
  # shellcheck disable=SC2034
  local config_disabled_validators=("${RPI_CONFIGURATION_VALIDATORS_DISABLED_ARRAY[@]}")
  local config_validator
  local config_validators=("${RPI_CONFIGURATION_VALIDATORS_ALL_ARRAY[@]}")

  for config_validator in "${config_validators[@]}"; do
    if ! stdlib.array.query.is_contains "${config_validator}" config_disabled_validators; then
      "_config_pictl_validation_${config_validator}"
    fi
  done
}

_config_pictl_validation_account() {
  _security_defaults_set
  _security_warning_single_user_mode
}

_config_pictl_validation_backup() {
  _backup_scheduler_validation
}

_config_pictl_validation_security() {
  _security_validate
}
