#!/bin/bash

setup() {
  _mock.create _help_callback

  _mock.create _disk_manifest_validation_configuration
  _mock.create _disk_manifest_validation_device
  _mock.create _disk_manifest_validation_filesystem

  _mock.create _mock_help_fn
}

@parametrize_with_validator_sets() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_DISABLED_VALIDATOR_SET_DEFINITION;TEST_EXPECTED_VALIDATOR_SET_DEFINITION" \
    "configuration_____device_____filesystem___;;configuration|device|filesystem" \
    "configuration_____no_device__filesystem___;device;configuration|filesystem" \
    "no_configuration__no_device__filesystem___;configuration|device;filesystem" \
    "no_configuration__no_device__no_filesystem;configuration|device|filesystem;;"
}

@parametrize_with_failing_validators() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_FAILING_VALIDATORS" \
    "fail__fail__fail;configuration|device|filesystem" \
    "fail__fail__pass;configuration|device" \
    "fail__pass__fail;configuration|filesystem" \
    "fail__pass__pass;configuration" \
    "pass__fail__pass;device" \
    "pass__fail__fail;device|filesystem" \
    "pass__pass__fail;filesystem" \
    "pass__pass__pass;;"
}

_fixture_identify_failing_validators() {
  if stdlib.array.query.is_contains "${1}" failing_validators; then
    "_disk_manifest_validation_${validator_name}.mock.set.rc" "127"
    expected_rc=127
  fi
}

# shellcheck disable=SC2034
test_disk_manifest_validation__@vary__@vary__calls_only_expected_validators() {
  local RPI_DISK_MANIFEST_VALIDATORS_DISABLED_ARRAY=()
  local expected_called_validators=()
  local expected_rc=0
  local expected_validators=()
  local failing_validators=()
  local validator_name

  stdlib.array.make.from_string RPI_DISK_MANIFEST_VALIDATORS_DISABLED_ARRAY "|" "${TEST_DISABLED_VALIDATOR_SET_DEFINITION}"
  stdlib.array.make.from_string expected_validators "|" "${TEST_EXPECTED_VALIDATOR_SET_DEFINITION}"
  stdlib.array.make.from_string failing_validators "|" "${TEST_FAILING_VALIDATORS}"
  for validator_name in "${expected_validators[@]}"; do
    [[ "${expected_rc}" -eq 0 ]] && expected_called_validators+=("${validator_name}")
    _fixture_identify_failing_validators "${validator_name}"
  done

  _disk_manifest_validation

  for validator_name in "${expected_called_validators[@]}"; do
    "_disk_manifest_validation_${validator_name}.mock.assert_called_once_with" ""
  done
}

@parametrize.compose \
  test_disk_manifest_validation__@vary__@vary__calls_only_expected_validators \
  @parametrize_with_validator_sets \
  @parametrize_with_failing_validators

# shellcheck disable=SC2034
test_disk_manifest_validation__@vary__@vary__returns_expected_status_code() {
  local RPI_DISK_MANIFEST_VALIDATORS_DISABLED_ARRAY=()
  local expected_rc=0
  local expected_validators=()
  local failing_validators=()
  local validator_name

  stdlib.array.make.from_string RPI_DISK_MANIFEST_VALIDATORS_DISABLED_ARRAY "|" "${TEST_DISABLED_VALIDATOR_SET_DEFINITION}"
  stdlib.array.make.from_string expected_validators "|" "${TEST_EXPECTED_VALIDATOR_SET_DEFINITION}"
  stdlib.array.make.from_string failing_validators "|" "${TEST_FAILING_VALIDATORS}"
  for validator_name in "${expected_validators[@]}"; do
    _fixture_identify_failing_validators "${validator_name}"
  done

  _capture.rc _disk_manifest_validation

  assert_rc "${expected_rc}"
}

@parametrize.compose \
  test_disk_manifest_validation__@vary__@vary__returns_expected_status_code \
  @parametrize_with_validator_sets \
  @parametrize_with_failing_validators
