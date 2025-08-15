#!/bin/bash

test_stdlib_string_map_format_var__default_delimiter__single_line__applies_printf() {
  TEST_OUTPUT="new line"

  stdlib.string.map.format_var "# %s" "TEST_OUTPUT"

  assert_equals "${TEST_OUTPUT}" "# new line"
}
