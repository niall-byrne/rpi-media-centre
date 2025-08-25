#!/bin/bash

# shellcheck disable=SC2034
setup_suite() {
  TEST_COLOURS=(
    STDLIB_THEME_LOGGER_ERROR
    STDLIB_THEME_LOGGER_WARNING
    STDLIB_THEME_LOGGER_INFO
    STDLIB_THEME_LOGGER_NOTICE
    STDLIB_THEME_LOGGER_SUCCESS
  )
}

test_stdlib_setting_theme_load__sets_all_theme_variables_to_non_null_values() {
  local colour

  for colour in "${TEST_COLOURS[@]}"; do
    printf -v "${colour}" "initial value"
    assert_equals "${!colour}" "initial value"
  done

  stdlib.setting.theme.load

  for colour in "${TEST_COLOURS[@]}"; do
    assert_not_equals "${!colour}" "initial value"
    assert_not_null "${!colour}"
  done
}
