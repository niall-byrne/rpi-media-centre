#!/bin/bash

# shellcheck disable=SC2034
setup() {
  _mock.create test_fn_original_reference
  _mock.create @parametrize._components.debug.message
  _mock.create test_fixture1
  _mock.create test_fixture2

  test_array_environment_variables=("VAR1" "VAR2")
  test_array_fixture_commands=("test_fixture1" "test_fixture2")
  test_array_scenario_definition=("mocked scenario name" "value 1" "value 2")
  received_environment_variables=()

  test_fn_original_reference.mock.set.subcommand \
    "received_environment_variables+=(\"\${VAR1}\"); received_environment_variables+=(\"\${VAR2}\")"
}

@parametrize_with_fn_name_toggle() {
  # $1: the test fn to parametrize

  @parametrize \
    "${1}" \
    "SHOW_FN_NAME_VALUE" \
    "show_fn_names_enabled;1" \
    "show_fn_names_disabled;0"
}

@parametrize_with_debug() {
  # $1: the test fn to parametrize

  @parametrize \
    "${1}" \
    "DEBUG_VALUE" \
    "debug_enabled;1" \
    "debug_disabled;0"
}

test_parametrize_components_create_fn_test_variant__debug_disabled__does_not_call_debug() {
  _PARAMETRIZE_DEBUG=0 @parametrize._components.create.fn.test_variant \
    "new_test_variant" \
    "test_fn" \
    "test_fn_original_reference" \
    test_array_environment_variables \
    test_array_fixture_commands \
    test_array_scenario_definition

  @parametrize._components.debug.message.mock.assert_not_called
}

test_parametrize_components_create_fn_test_variant__debug_enabled___calls_debug_as_expected() {
  _PARAMETRIZE_DEBUG=1 @parametrize._components.create.fn.test_variant \
    "new_test_variant" \
    "test_fn" \
    "test_fn_original_reference" \
    test_array_environment_variables \
    test_array_fixture_commands \
    test_array_scenario_definition

  @parametrize._components.debug.message.mock.assert_called_once_with "1(
$(_testing.message.get PARAMETRIZE_HEADER_SCENARIO): \"${test_array_scenario_definition[0]}\"
VAR1: \"value 1\"
VAR2: \"value 2\"
$(_testing.message.get PARAMETRIZE_PREFIX_FIXTURE_COMMAND): \"test_fixture1\"
$(_testing.message.get PARAMETRIZE_PREFIX_FIXTURE_COMMAND): \"test_fixture2\"
)"
}

test_parametrize_components_create_fn_test_variant__creates_test_fn() {
  _PARAMETRIZE_DEBUG=0 @parametrize._components.create.fn.test_variant \
    "new_test_variant" \
    "test_fn" \
    "test_fn_original_reference" \
    test_array_environment_variables \
    test_array_fixture_commands \
    test_array_scenario_definition

  assert_is_fn new_test_variant
}

test_parametrize_components_create_fn_test_variant__@vary__test_fn________when_called__show_fn_names_enabled___generates_correct_stdout() {
  _PARAMETRIZE_DEBUG="${DEBUG_VALUE}" \
    _PARAMETRIZE_SHOW_ORIGINAL_TEST_NAMES=1 \
    @parametrize._components.create.fn.test_variant \
    "new_test_variant" \
    "test_fn" \
    "test_fn_original_reference" \
    test_array_environment_variables \
    test_array_fixture_commands \
    test_array_scenario_definition

  _capture.stdout new_test_variant

  assert_output $'\n'"                $(
    stdlib.string.colour "${STDLIB_TESTING_THEME_PARAMETRIZE_ORIGINAL_TEST_NAMES}" \
      "test_fn ..."
  )"
}

@parametrize_with_debug \
  test_parametrize_components_create_fn_test_variant__@vary__test_fn________when_called__show_fn_names_enabled___generates_correct_stdout

test_parametrize_components_create_fn_test_variant__@vary__test_fn________when_called__show_fn_names_disabled__generates_correct_stdout() {
  _PARAMETRIZE_DEBUG="${DEBUG_VALUE}" \
    _PARAMETRIZE_SHOW_ORIGINAL_TEST_NAMES=0 \
    @parametrize._components.create.fn.test_variant \
    "new_test_variant" \
    "test_fn" \
    "test_fn_original_reference" \
    test_array_environment_variables \
    test_array_fixture_commands \
    test_array_scenario_definition

  _capture.stdout new_test_variant

  assert_output_null
}

@parametrize_with_debug \
  test_parametrize_components_create_fn_test_variant__@vary__test_fn________when_called__show_fn_names_disabled__generates_correct_stdout

test_parametrize_components_create_fn_test_variant__@vary__test_fn________when_called__@vary__calls_original_fn_reference() {
  _PARAMETRIZE_DEBUG="${DEBUG_VALUE}" \
    _PARAMETRIZE_SHOW_ORIGINAL_TEST_NAMES="${SHOW_FN_NAME_VALUE}" \
    @parametrize._components.create.fn.test_variant \
    "new_test_variant" \
    "test_fn" \
    "test_fn_original_reference" \
    test_array_environment_variables \
    test_array_fixture_commands \
    test_array_scenario_definition

  new_test_variant

  test_fn_original_reference.mock.assert_called_once_with ""
}

@parametrize.compose \
  test_parametrize_components_create_fn_test_variant__@vary__test_fn________when_called__@vary__calls_original_fn_reference \
  @parametrize_with_debug \
  @parametrize_with_fn_name_toggle

test_parametrize_components_create_fn_test_variant__@vary__test_fn________when_called__@vary__calls_fixture_functions() {
  _PARAMETRIZE_DEBUG="${DEBUG_VALUE}" \
    _PARAMETRIZE_SHOW_ORIGINAL_TEST_NAMES="${SHOW_FN_NAME_VALUE}" \
    @parametrize._components.create.fn.test_variant \
    "new_test_variant" \
    "test_fn" \
    "test_fn_original_reference" \
    test_array_environment_variables \
    test_array_fixture_commands \
    test_array_scenario_definition

  new_test_variant

  test_fixture1.mock.assert_called_once_with ""
  test_fixture2.mock.assert_called_once_with ""
}

@parametrize.compose \
  test_parametrize_components_create_fn_test_variant__@vary__test_fn________when_called__@vary__calls_fixture_functions \
  @parametrize_with_debug \
  @parametrize_with_fn_name_toggle

test_parametrize_components_create_fn_test_variant__@vary__test_fn________when_called__@vary__calls_the_fixtures_and_original_fn_in_correct_sequence() {
  local expected_sequence=("test_fixture1" "test_fixture2" "test_fn_original_reference")

  _mock.sequence.record.start
  [[ "${DEBUG_VALUE}" == "1" ]] && stdlib.array.mutate.insert "@parametrize._components.debug.message" 0 expected_sequence

  _PARAMETRIZE_DEBUG="${DEBUG_VALUE}" \
    _PARAMETRIZE_SHOW_ORIGINAL_TEST_NAMES="${SHOW_FN_NAME_VALUE}" \
    @parametrize._components.create.fn.test_variant \
    "new_test_variant" \
    "test_fn" \
    "test_fn_original_reference" \
    test_array_environment_variables \
    test_array_fixture_commands \
    test_array_scenario_definition

  new_test_variant

  _mock.sequence.assert_is "${expected_sequence[@]}"
}

@parametrize.compose \
  test_parametrize_components_create_fn_test_variant__@vary__test_fn________when_called__@vary__calls_the_fixtures_and_original_fn_in_correct_sequence \
  @parametrize_with_debug \
  @parametrize_with_fn_name_toggle

test_parametrize_components_create_fn_test_variant__@vary__test_fn________when_called__@vary__sets_environment_variables() {
  expected_environment_variables=("${test_array_scenario_definition[@]:1}")

  _PARAMETRIZE_DEBUG="${DEBUG_VALUE}" \
    _PARAMETRIZE_SHOW_ORIGINAL_TEST_NAMES="${SHOW_FN_NAME_VALUE}" \
    @parametrize._components.create.fn.test_variant \
    "new_test_variant" \
    "test_fn" \
    "test_fn_original_reference" \
    test_array_environment_variables \
    test_array_fixture_commands \
    test_array_scenario_definition

  new_test_variant

  assert_array_equals expected_environment_variables received_environment_variables
}

@parametrize.compose \
  test_parametrize_components_create_fn_test_variant__@vary__test_fn________when_called__@vary__sets_environment_variables \
  @parametrize_with_debug \
  @parametrize_with_fn_name_toggle

test_parametrize_components_create_fn_test_variant__@vary__test_fn________when_called__@vary__sets_scenario_name_variable() {
  local PARAMETRIZE_SCENARIO_NAME

  expected_environment_variables=("${test_array_scenario_definition[@]:1}")
  test_fn_original_reference.mock.set.keywords "PARAMETRIZE_SCENARIO_NAME"

  _PARAMETRIZE_DEBUG="${DEBUG_VALUE}" \
    _PARAMETRIZE_SHOW_ORIGINAL_TEST_NAMES="${SHOW_FN_NAME_VALUE}" \
    @parametrize._components.create.fn.test_variant \
    "new_test_variant" \
    "test_fn" \
    "test_fn_original_reference" \
    test_array_environment_variables \
    test_array_fixture_commands \
    test_array_scenario_definition

  new_test_variant

  test_fn_original_reference.mock.assert_called_once_with \
    "PARAMETRIZE_SCENARIO_NAME(${test_array_scenario_definition[0]})"
}

@parametrize.compose \
  test_parametrize_components_create_fn_test_variant__@vary__test_fn________when_called__@vary__sets_scenario_name_variable \
  @parametrize_with_debug \
  @parametrize_with_fn_name_toggle
