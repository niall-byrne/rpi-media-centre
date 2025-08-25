#!/bin/bash

# shellcheck disable=SC2034,SC2016
test_parametrize_components_create_padded_test_fn_variant_name__padding_20__outputs_correct_value() {
  local _PARAMETRIZE_VARIANT_TAG="@vary"

  _capture.output @parametrize._components.create.string.padded_test_fn_variant_name \
    "test_mock_function_name_one__@vary__testing" \
    "scenario_name" \
    "20"

  assert_output "test_mock_function_name_one__scenario_name_________testing"
}

# shellcheck disable=SC2034,SC2016
test_parametrize_components_create_padded_test_fn_variant_name__padding_30__outputs_correct_value() {
  local _PARAMETRIZE_VARIANT_TAG="@vary"

  _capture.output @parametrize._components.create.string.padded_test_fn_variant_name \
    "test_mock_function_name_two__@vary__testing" \
    "scenario_name" \
    "30"

  assert_output "test_mock_function_name_two__scenario_name___________________testing"
}
