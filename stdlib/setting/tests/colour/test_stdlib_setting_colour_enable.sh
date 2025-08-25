#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/setting/tests/colour/__fixtures__/colour.sh"

test_stdlib_setting_colour_enable__sets_all_colour_variables_to_non_null_values() {
  local colour

  for colour in "${TEST_COLOURS[@]}"; do
    printf -v "${colour}" "initial value"
    assert_equals "${!colour}" "initial value"
  done

  stdlib.setting.colour.enable

  for colour in "${TEST_COLOURS[@]}"; do
    assert_not_equals "${!colour}" "initial value"
    assert_not_null "${!colour}"
  done
}
