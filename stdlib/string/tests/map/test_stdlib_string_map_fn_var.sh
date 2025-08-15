#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/string/tests/map/__fixtures__/map_fn.sh"

setup() {
  _mock.create stdlib.logger.error
}

test_stdlib_string_map_fn_var__default_delimiter__single_line__applies_fn() {
  TEST_OUTPUT="new line"

  stdlib.string.map.fn_var _uppercase "TEST_OUTPUT"

  assert_equals "UPPERCASE: NEW LINE" "${TEST_OUTPUT}"
}
