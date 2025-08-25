#!/bin/bash

test_stdlib_string_lines_map_format_pipe__default_delimiter__single_line__applies_printf() {
  TEST_OUTPUT="$(echo "new line" | stdlib.string.lines.map.format_pipe "# %s")"

  assert_equals "${TEST_OUTPUT}" "# new line"
}
