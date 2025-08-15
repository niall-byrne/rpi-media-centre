#!/bin/bash

test_stdlib_testing_fixtures_debug_diff__values_are_the_same___generates_correct_stdout() {
  _capture.stdout _testing.fixtures.debug.diff "value 1" "value 1"

  assert_output "== Start Debug Diff ==
${STDLIB_COLOUR_GREY}EXPECTED:${STDLIB_COLOUR_NC}
value\ 1
${STDLIB_COLOUR_GREY}ACTUAL:${STDLIB_COLOUR_NC}
value\ 1
${STDLIB_COLOUR_GREY}DIFF:${STDLIB_COLOUR_NC}
== End Debug Diff =="
}

test_stdlib_testing_fixtures_debug_diff__values_are_different__generates_correct_stdout() {
  _capture.stdout _testing.fixtures.debug.diff "value 1" "value 2"

  assert_output "== Start Debug Diff ==
${STDLIB_COLOUR_GREY}EXPECTED:${STDLIB_COLOUR_NC}
value\ 1
${STDLIB_COLOUR_GREY}ACTUAL:${STDLIB_COLOUR_NC}
value\ 2
${STDLIB_COLOUR_GREY}DIFF:${STDLIB_COLOUR_NC}
1c1
< value 1
\ No newline at end of file
---
> value 2
\ No newline at end of file
== End Debug Diff =="
}
