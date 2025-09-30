#!/bin/bash

setup() {
  _mock.create _configuration_pictl_validation_account
  _mock.create _configuration_pictl_validation_backup
  _mock.create _configuration_pictl_validation_security
}

@parametrize_with_validator_sets() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_DISABLED_VALIDATOR_SET_DEFINITION;TEST_EXPECTED_VALIDATOR_SET_DEFINITION" \
    "account_____backup_____security___;;account|backup|security" \
    "no_account__backup_____security___;account;backup|security" \
    "account_____no_backup__security___;backup|security;account" \
    "account_____backup_____no_security;security;account|backup" \
    "account_____no_backup__no_security;backup|security;account" \
    "no_account__backup_____no_security;security;account|backup" \
    "no_account__no_backup__security___;account|backup;security" \
    "no_account__no_backup__no_security;account|backup|security;;"
}

# shellcheck disable=SC2034
test_configuration_pictl_validation__default_____________________________calls_expected_validators() {
  _configuration_pictl_validation

  for validator_name in "${RPI_CONFIGURATION_VALIDATORS_ALL_ARRAY[@]}"; do
    "_configuration_pictl_validation_${validator_name}.mock.assert_called_once_with" ""
  done
}

# shellcheck disable=SC2034
test_configuration_pictl_validation__@vary__calls_expected_validators() {
  local expected_validators
  local RPI_CONFIGURATION_VALIDATORS_DISABLED_ARRAY=()

  stdlib.array.make.from_string RPI_CONFIGURATION_VALIDATORS_DISABLED_ARRAY "|" "${TEST_DISABLED_VALIDATOR_SET_DEFINITION}"
  stdlib.array.make.from_string expected_validators "|" "${TEST_EXPECTED_VALIDATOR_SET_DEFINITION}"

  _configuration_pictl_validation

  for validator_name in "${expected_validators[@]}"; do
    "_configuration_pictl_validation_${validator_name}.mock.assert_called_once_with" ""
  done
}

@parametrize_with_validator_sets \
  test_configuration_pictl_validation__@vary__calls_expected_validators
