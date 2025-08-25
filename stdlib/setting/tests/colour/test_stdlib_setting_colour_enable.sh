#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/setting/tests/colour/__fixtures__/colour.sh"

setup() {
  _mock.create stdlib.setting.colour.enable._generate_error_message
  _mock.create stdlib.setting.colour.disable
}

test_stdlib_setting_colour_enable__tput_fails_____silent_fallback___does_not_generate_error_message() {
  local _STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="1"
  local TERM=""

  stdlib.setting.colour.enable

  stdlib.setting.colour.enable._generate_error_message.mock.assert_not_called
}

test_stdlib_setting_colour_enable__tput_fails_____silent_fallback___disables_colours() {
  local _STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="1"
  local TERM=""

  _capture.rc stdlib.setting.colour.enable

  stdlib.setting.colour.disable.mock.assert_called_once_with ""
}

test_stdlib_setting_colour_enable__tput_fails_____silent_fallback___returns_status_code_0() {
  local _STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="1"
  local TERM=""

  _capture.rc stdlib.setting.colour.enable

  assert_rc "0"
}

test_stdlib_setting_colour_enable__tput_fails_____silent_fallback___does_not_set_call_colour_values() {
  local _STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="1"
  local TERM=""
  local colour

  for colour in "${TEST_COLOURS[@]}"; do
    printf -v "${colour}" "initial value"
    assert_equals "${!colour}" "initial value"
  done

  stdlib.setting.colour.enable

  for colour in "${TEST_COLOURS[@]}"; do
    assert_equals "${!colour}" "initial value"
  done
}

test_stdlib_setting_colour_enable__tput_fails_____verbose_failure___generates_error_message() {
  local _STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="0"
  local TERM=""

  stdlib.setting.colour.enable

  stdlib.setting.colour.enable._generate_error_message.mock.assert_called_once_with ""
}

test_stdlib_setting_colour_enable__tput_fails_____verbose_failure___does_not_disable_colours() {
  local _STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="0"
  local TERM=""

  _capture.rc stdlib.setting.colour.enable

  stdlib.setting.colour.disable.mock.assert_not_called
}

test_stdlib_setting_colour_enable__tput_fails_____verbose_failure___returns_status_code_127() {
  local _STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="0"
  local TERM=""

  _capture.rc stdlib.setting.colour.enable

  assert_rc "127"
}

test_stdlib_setting_colour_enable__tput_fails_____verbose_failure___does_not_set_call_colour_values() {
  local _STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="0"
  local TERM=""
  local colour

  for colour in "${TEST_COLOURS[@]}"; do
    printf -v "${colour}" "initial value"
    assert_equals "${!colour}" "initial value"
  done

  stdlib.setting.colour.enable

  for colour in "${TEST_COLOURS[@]}"; do
    assert_equals "${!colour}" "initial value"
  done
}

test_stdlib_setting_colour_enable__tput_succeeds__silent_fallback___does_not_generate_error_message() {
  local _STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="1"
  local TERM="xterm"

  stdlib.setting.colour.enable

  stdlib.setting.colour.enable._generate_error_message.mock.assert_not_called
}

test_stdlib_setting_colour_enable__tput_succeeds__silent_fallback___does_not_disable_colours() {
  local _STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="1"
  local TERM="xterm"

  _capture.rc stdlib.setting.colour.enable

  stdlib.setting.colour.disable.mock.assert_not_called
}

test_stdlib_setting_colour_enable__tput_succeeds__silent_fallback___returns_status_code_0() {
  local _STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="1"
  local TERM="xterm"

  _capture.rc stdlib.setting.colour.enable

  assert_rc "0"
}

test_stdlib_setting_colour_enable__tput_succeeds__silent_fallback___sets_all_colour_variables_to_non_null_values() {
  local _STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="1"
  local TERM="xterm"
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

test_stdlib_setting_colour_enable__tput_succeeds__verbose_failure___does_not_generate_error_message() {
  local _STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="0"
  local TERM="xterm"

  stdlib.setting.colour.enable

  stdlib.setting.colour.enable._generate_error_message.mock.assert_not_called
}

test_stdlib_setting_colour_enable__tput_succeeds__verbose_failure___does_not_disable_colours() {
  local _STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="1"
  local TERM="xterm"

  _capture.rc stdlib.setting.colour.enable

  stdlib.setting.colour.disable.mock.assert_not_called
}

test_stdlib_setting_colour_enable__tput_succeeds__verbose_failure___returns_status_code_0() {
  local _STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="0"
  local TERM="xterm"

  _capture.rc stdlib.setting.colour.enable

  assert_rc "0"
}

test_stdlib_setting_colour_enable__tput_succeeds__verbose_failure___sets_all_colour_variables_to_non_null_values() {
  local _STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="0"
  local TERM="xterm"
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
