#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/tests/io/__fixtures__/theme.sh"

setup() {
  _mock.create source
}

assert_theme_values_are_set() {
  # $@:  An array of indexes in the RPI_THEME_COMPONENTS array that will not be set during loading

  # shellcheck disable=SC2034
  local excluded_indexes=("${@}")
  local index
  local theme_component

  for ((index = 0; index < "${#RPI_THEME_COMPONENTS[*]}"; index++)); do
    theme_component="${RPI_THEME_COMPONENTS[index]}"
    if stdlib.array.query.is_contains "${index}" excluded_indexes; then
      assert_null "${!theme_component}"
    else
      assert_equals "MOCKED_STDLIB_${theme_component}_COLOUR_VALUE" "${!theme_component}"
    fi
  done
}

# shellcheck disable=SC2120
assert_theme_logger_values_are_set() {
  # $@:  An array of indexes in the RPI_LOGGER_THEME_COMPONENTS array that will not be set during loading

  # shellcheck disable=SC2034
  local excluded_indexes=("${@}")
  local index
  local theme_component

  for ((index = 0; index < "${#RPI_LOGGER_THEME_COMPONENTS[*]}"; index++)); do
    theme_component="${RPI_LOGGER_THEME_COMPONENTS[index]}"

    stdlib_theme_component="STDLIB_${theme_component}"
    original_theme_component_value="ORIGINAL_${theme_component}"

    if stdlib.array.query.is_contains "${index}" excluded_indexes; then
      assert_null "${!theme_component}"
      assert_not_null "${!stdlib_theme_component}"
    else
      assert_equals "MOCKED_STDLIB_${theme_component}_COLOUR_VALUE" "${!theme_component}"
      assert_equals "${!original_theme_component_value}" "${!stdlib_theme_component}"
    fi
  done
}

@parametrize_with_scenarios() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_THEME_FIXTURE;TEST_COLOUR_FIXTURE;TEST_ASSERTION_FN_ARGS" \
    "complete_theme____valid_colours_____;_fixture_mocked_complete_theme;_fixture_mocked_valid_colours;;" \
    "complete_theme____one_invalid_colour;_fixture_mocked_complete_theme;_fixture_one_invalid_colour;1" \
    "incomplete_theme__valid_colours_____;_fixture_mocked_incomplete_theme;_fixture_mocked_valid_colours;2" \
    "incomplete_theme__one_invalid_colour;_fixture_mocked_incomplete_theme;_fixture_one_invalid_colour;1|2"
}

test_io_theme_load__@vary__sources_theme_file_as_expected() {
  local RPI_COLOUR_THEME="mock_theme.sh"

  "${TEST_THEME_FIXTURE}"
  "${TEST_COLOUR_FIXTURE}"

  _io_theme_load

  source.mock.assert_called_once_with \
    "1(${RPI_WORKING_DIRECTORY}/lib/cli/theme/${RPI_COLOUR_THEME}.sh)"
}

@parametrize_with_scenarios \
  test_io_theme_load__@vary__sources_theme_file_as_expected

# shellcheck disable=SC2153
test_io_theme_load__@vary__sets_the_theme_values_correctly() {
  local RPI_COLOUR_THEME="mock_theme.sh"
  local assertion_args=()

  stdlib.array.make.from_string assertion_args "|" "${TEST_ASSERTION_FN_ARGS}"
  "${TEST_THEME_FIXTURE}"
  "${TEST_COLOUR_FIXTURE}"

  _io_theme_load

  assert_theme_values_are_set "${assertion_args[@]}"
}

@parametrize_with_scenarios \
  test_io_theme_load__@vary__sets_the_theme_values_correctly

# shellcheck disable=SC2153
test_io_theme_load__@vary__sets_the_nc_theme_value() {
  local RPI_COLOUR_THEME="mock_theme.sh"

  "${TEST_THEME_FIXTURE}"
  "${TEST_COLOUR_FIXTURE}"

  _io_theme_load

  assert_equals "MOCKED_STDLIB_THEME_NC_COLOUR_VALUE" "${THEME_NC}"
}

@parametrize_with_scenarios \
  test_io_theme_load__@vary__sets_the_nc_theme_value

# shellcheck disable=SC2153
test_io_theme_load__@vary__maps_theme_logger_components_to_stdlib() {
  local RPI_COLOUR_THEME="mock_theme.sh"
  local theme_component
  local stdlib_theme_component

  "${TEST_THEME_FIXTURE}"
  _fixture_mocked_complete_theme_logger
  "${TEST_COLOUR_FIXTURE}"

  _io_theme_load

  assert_theme_logger_values_are_set
}

@parametrize_with_scenarios \
  test_io_theme_load__@vary__maps_theme_logger_components_to_stdlib

# shellcheck disable=SC2153
test_io_theme_load__@vary__unset_theme_logger_components_revert_to_stdlib_defaults() {
  local RPI_COLOUR_THEME="mock_theme.sh"
  local theme_component
  local original_theme_component_value
  local stdlib_theme_component

  "${TEST_THEME_FIXTURE}"
  _fixture_mocked_incomplete_theme_logger
  "${TEST_COLOUR_FIXTURE}"

  _io_theme_load

  assert_theme_logger_values_are_set 3
}

@parametrize_with_scenarios \
  test_io_theme_load__@vary__unset_theme_logger_components_revert_to_stdlib_defaults
