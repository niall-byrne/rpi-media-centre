#!/bin/bash

test_pictl_cli__integration__config__no_command____shows_correct_menu() {
  _capture.output _pictl_cli config

  assert_snapshot "__fixtures__/config.txt"
}

test_pictl_cli__integration__config__no_command____return_code_127() {
  _capture.rc _pictl_cli config > /dev/null

  assert_rc "127"
}

test_pictl_cli__integration__config__help_command__shows_correct_menu() {
  _capture.output _pictl_cli config help

  assert_snapshot "__fixtures__/config.txt"
}

test_pictl_cli__integration__config__help_command__return_code_0() {
  _capture.rc _pictl_cli config help > /dev/null

  assert_rc "0"
}
