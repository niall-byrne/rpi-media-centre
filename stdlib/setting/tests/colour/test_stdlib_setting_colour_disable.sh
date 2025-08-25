#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/setting/tests/colour/__fixtures__/colour.sh"

test_stdlib_setting_colour_disable__sets_all_colour_variables_to_null_values() {
  local colour

  for colour in "${TEST_COLOURS[@]}"; do
    printf -v "${colour}" "initial value"
    assert_equals "${!colour}" "initial value"
  done

  stdlib.setting.colour.disable

  for colour in "${TEST_COLOURS[@]}"; do
    assert_null "${!colour}"
  done
}
