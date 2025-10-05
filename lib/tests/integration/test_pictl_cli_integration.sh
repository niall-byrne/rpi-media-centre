#!/bin/bash

test_pictl_cli__integration__no_command____shows_correct_menu() {
  _capture.output _pictl_cli

  assert_snapshot "__fixtures__/pictl.txt"
}

test_pictl_cli__integration__no_command____return_code_127() {
  _capture.rc _pictl_cli > /dev/null

  assert_rc "127"
}

test_pictl_cli__integration__help_command__shows_correct_menu() {
  _capture.output _pictl_cli help

  assert_snapshot "__fixtures__/pictl.txt"
}

test_pictl_cli__integration__help_command__return_code_0() {
  _capture.rc _pictl_cli help > /dev/null

  assert_rc "0"
}
