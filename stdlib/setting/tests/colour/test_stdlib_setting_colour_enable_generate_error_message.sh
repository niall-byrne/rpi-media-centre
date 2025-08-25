#!/bin/bash

test_stdlib_setting_colour_enable_generate_error_message__term_set______generates_expected_stderr() {
  local TERM="xterm"

  _capture.stderr_raw stdlib.setting.colour.enable._generate_error_message

  assert_output "$(stdlib.message.get COLOUR_INITIALIZE_ERROR)"$'\n'
}

test_stdlib_setting_colour_enable_generate_error_message__term_not_set__generates_expected_stderr() {
  local TERM=""

  _capture.stderr_raw stdlib.setting.colour.enable._generate_error_message

  assert_output "$(stdlib.message.get COLOUR_INITIALIZE_ERROR)
$(stdlib.message.get COLOUR_INITIALIZE_ERROR_TERM)
"
}
