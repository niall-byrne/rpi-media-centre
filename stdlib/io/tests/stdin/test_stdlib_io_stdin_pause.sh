#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

test_stdlib_io_stdin_pause__null_prompt__returns_expected_status_code() {
  _capture.rc stdlib.io.stdin.pause ""

  assert_rc "126"
}

test_stdlib_io_stdin_pause__extra_arg____returns_expected_status_code() {
  _capture.rc stdlib.io.stdin.pause "mock_prompt" "extra_arg"

  assert_rc "127"
}

test_stdlib_io_stdin_pause__valid_args___default_prompt__displays_prompt_as_expected() {
  _capture.output stdlib.io.stdin.pause <<< " "

  assert_output "$(stdlib.message.get STDIN_DEFAULT_PAUSE_PROMPT)"
}

test_stdlib_io_stdin_pause__valid_args___custom_prompt___displays_prompt_as_expected() {
  _capture.output stdlib.io.stdin.pause "custom prompt" <<< " "

  assert_output "custom prompt"
}
