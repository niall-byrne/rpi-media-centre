#!/bin/bash

#!/bin/bash

#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_keystrokes() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_KEY_STROKES,TEST_EXPECTED_RC" \
    "simple_Y__,Y,0" \
    "simple_n__,n,1" \
    "many_keystrokes_ending_in_n,abcdefghijklmnn,1" \
    "many_keystrokes_ending_in_Y,ABCDEFGHIJKLMNOPQRSTUVWXY,0"
}

test_stdlib_io_stdin_confirmation__null_prompt__________________returns_expected_status_code() {
  _capture.rc stdlib.io.stdin.confirmation ""

  assert_rc "126"
}

test_stdlib_io_stdin_confirmation__extra_arg____________________returns_expected_status_code() {
  _capture.rc stdlib.io.stdin.confirmation "mock_prompt" "extra_arg"

  assert_rc "127"
}

test_stdlib_io_stdin_confirmation__@vary__returns_expected_status_code() {
  _capture.rc stdlib.io.stdin.confirmation <<< "${TEST_KEY_STROKES}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_keystrokes \
  test_stdlib_io_stdin_confirmation__@vary__returns_expected_status_code

test_stdlib_io_stdin_confirmation__valid_key_strokes____________calls_read_as_expected() {
  _mock.create read
  read.mock.set.subcommand "input_char='Y'"

  stdlib.io.stdin.confirmation > /dev/null

  unset -f read
  read.mock.assert_called_once_with "-rs -n 1 input_char"
}

test_stdlib_io_stdin_confirmation__valid_key_strokes____________default_prompt__displays_prompt_as_expected() {
  _capture.output stdlib.io.stdin.confirmation <<< "Y"

  assert_output "Are you sure you wish to proceed (Y/n) ? "
}

test_stdlib_io_stdin_confirmation__valid_key_strokes____________custom_prompt___displays_prompt_as_expected() {
  _capture.output stdlib.io.stdin.confirmation "custom prompt" <<< "Y"

  assert_output "custom prompt"
}
