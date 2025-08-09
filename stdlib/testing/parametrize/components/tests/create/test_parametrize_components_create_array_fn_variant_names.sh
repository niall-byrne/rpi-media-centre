#!/bin/bash

setup() {
  _mock.create @parametrize._components.validate.fn_name.parametrizer

  TEST_FUNCTION_STACK=(
    "@parametrize_with_variant_1"
    "@parametrize_with_variant_2"
    "@parametrize_with_variant_30"
    "@parametrize_with_variant_40"
  )
}

# shellcheck disable=SC2034,SC2016
test_parametrize_components_create_fn_variant_tags__creates_correct_variant_stack() {
  local EXPECTED_STACK_VARIANTS=(
    "variant_1"
    "variant_2"
    "variant_30"
    "variant_40"
  )

  local _PARAMETRIZED_STACK_VARIANTS=()
  local _PARAMETRIZE_MULTIPLE_PREFIX="@parametrize_with_"
  local _PARAMETRIZED_PADDING_VALUE

  @parametrize._components.create.array.fn_variant_tags "${TEST_FUNCTION_STACK[@]}"

  assert_array_equals EXPECTED_STACK_VARIANTS _PARAMETRIZED_STACK_VARIANTS
}

# shellcheck disable=SC2034,SC2016
test_parametrize_components_create_fn_variant_tags__validates_each_variant_name() {
  local _PARAMETRIZED_STACK_VARIANTS=()
  local _PARAMETRIZE_MULTIPLE_PREFIX="@parametrize_with_"
  local _PARAMETRIZED_PADDING_VALUE

  @parametrize._components.create.array.fn_variant_tags "${TEST_FUNCTION_STACK[@]}"

  @parametrize._components.validate.fn_name.parametrizer.mock.assert_calls_are \
    "${TEST_FUNCTION_STACK[@]}"
}

# shellcheck disable=SC2034,SC2016
test_parametrize_components_create_fn_variant_tags__sets_correct_padding_value() {
  local _PARAMETRIZED_STACK_VARIANTS=()
  local _PARAMETRIZE_MULTIPLE_PREFIX="@parametrize_with_"
  local _PARAMETRIZED_PADDING_VALUE

  @parametrize._components.create.array.fn_variant_tags "${TEST_FUNCTION_STACK[@]}"

  assert_equals "10" "${_PARAMETRIZED_PADDING_VALUE}"
}
