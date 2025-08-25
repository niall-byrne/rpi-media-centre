#!/bin/bash

setup() {
  _mock.create stdlib.logger.warning
}

test_stdlib_setting_theme_get_colour__red_____________correct_output() {
  TEST_EXPECTED="STDLIB_COLOUR_RED"$'\n'

  _capture.stdout_raw stdlib.setting.theme.get_colour "RED"

  assert_output "${TEST_EXPECTED}"
}

test_stdlib_setting_theme_get_colour__green___________correct_output() {
  TEST_EXPECTED="STDLIB_COLOUR_GREEN"$'\n'

  _capture.stdout_raw stdlib.setting.theme.get_colour "GREEN"

  assert_output "${TEST_EXPECTED}"
}

test_stdlib_setting_theme_get_colour__invalid_colour__logs_warning() {
  _capture.stdout_raw stdlib.setting.theme.get_colour "NON_EXISTENT"

  stdlib.logger.warning.mock.assert_called_once_with \
    "1($(stdlib.message.get COLOUR_NOT_DEFINED NON_EXISTENT))"
}
