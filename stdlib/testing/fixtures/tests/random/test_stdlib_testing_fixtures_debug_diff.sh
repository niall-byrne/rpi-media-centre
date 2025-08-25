#!/bin/bash

# shellcheck disable=SC2034
setup_suite() {
  expected_colour="$(stdlib.setting.theme.get_colour "${STDLIB_TESTING_THEME_DEBUG_FIXTURE}")"
}

test_stdlib_testing_fixtures_debug_diff__values_are_the_same___generates_correct_stdout() {
  _capture.stdout _testing.fixtures.debug.diff "value 1" "value 1"

  assert_output "$(_testing.message.get DEBUG_DIFF_HEADER)
${!expected_colour}$(_testing.message.get DEBUG_DIFF_PREFIX_EXPECTED):${STDLIB_COLOUR_NC}
value\ 1
${!expected_colour}$(_testing.message.get DEBUG_DIFF_PREFIX_ACTUAL):${STDLIB_COLOUR_NC}
value\ 1
${!expected_colour}$(_testing.message.get DEBUG_DIFF_PREFIX):${STDLIB_COLOUR_NC}
$(_testing.message.get DEBUG_DIFF_FOOTER)"
}

test_stdlib_testing_fixtures_debug_diff__values_are_different__generates_correct_stdout() {
  _capture.stdout _testing.fixtures.debug.diff "value 1" "value 2"

  assert_output "$(_testing.message.get DEBUG_DIFF_HEADER)
${!expected_colour}$(_testing.message.get DEBUG_DIFF_PREFIX_EXPECTED):${STDLIB_COLOUR_NC}
value\ 1
${!expected_colour}$(_testing.message.get DEBUG_DIFF_PREFIX_ACTUAL):${STDLIB_COLOUR_NC}
value\ 2
${!expected_colour}$(_testing.message.get DEBUG_DIFF_PREFIX):${STDLIB_COLOUR_NC}
1c1
< value 1
\ No newline at end of file
---
> value 2
\ No newline at end of file
$(_testing.message.get DEBUG_DIFF_FOOTER)"
}
