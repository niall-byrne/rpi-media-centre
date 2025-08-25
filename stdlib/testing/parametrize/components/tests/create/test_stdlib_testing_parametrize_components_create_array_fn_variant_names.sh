#!/bin/bash

# shellcheck disable=SC2034,SC2016
setup() {
  _mock.create @parametrize._components.validate.fn_name.parametrizer

  TEST_FUNCTION_STACK=(
    "@parametrize_with_variant_1"
    "@parametrize_with_variant_2"
    "@parametrize_with_variant_30"
    "@parametrize_with_variant_40"
  )
  local test_stack_variants=()
  local test_padding_value
}

test_parametrize_components_create_fn_variant_tags__valid_args____creates_correct_variant_stack() {
  local _PARAMETRIZE_PARAMETRIZER_PREFIX="@parametrize_with_"
  local expected_stack_variants=(
    "variant_1"
    "variant_2"
    "variant_30"
    "variant_40"
  )

  @parametrize._components.create.array.fn_variant_tags \
    test_padding_value \
    test_stack_variants \
    "${TEST_FUNCTION_STACK[@]}"

  assert_array_equals expected_stack_variants test_stack_variants
}

test_parametrize_components_create_fn_variant_tags__valid_args____validates_each_variant_name() {
  local _PARAMETRIZE_PARAMETRIZER_PREFIX="@parametrize_with_"

  @parametrize._components.create.array.fn_variant_tags \
    test_padding_value \
    test_stack_variants \
    "${TEST_FUNCTION_STACK[@]}"

  stdlib.array.mutate.format "1(%s)" TEST_FUNCTION_STACK

  @parametrize._components.validate.fn_name.parametrizer.mock.assert_calls_are \
    "${TEST_FUNCTION_STACK[@]}"
}

test_parametrize_components_create_fn_variant_tags__valid_args____sets_correct_padding_value() {
  local _PARAMETRIZE_PARAMETRIZER_PREFIX="@parametrize_with_"

  @parametrize._components.create.array.fn_variant_tags \
    test_padding_value \
    test_stack_variants \
    "${TEST_FUNCTION_STACK[@]}"

  assert_equals "10" "${test_padding_value}"
}

test_parametrize_components_create_fn_variant_tags__valid_args____returns_status_code_0() {
  local _PARAMETRIZE_PARAMETRIZER_PREFIX="@parametrize_with_"

  _capture.rc @parametrize._components.create.array.fn_variant_tags \
    test_padding_value \
    test_stack_variants \
    "${TEST_FUNCTION_STACK[@]}"

  assert_rc "0"
}

test_parametrize_components_create_fn_variant_tags__invalid_args__returns_status_code_126() {
  local _PARAMETRIZE_PARAMETRIZER_PREFIX="@parametrize_with_"
  @parametrize._components.validate.fn_name.parametrizer.mock.set.rc 1

  _capture.rc @parametrize._components.create.array.fn_variant_tags \
    test_padding_value \
    test_stack_variants \
    "${TEST_FUNCTION_STACK[@]}"

  assert_rc "126"
}
