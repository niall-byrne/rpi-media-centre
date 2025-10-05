#!/bin/bash

test_pictl_cli__integration__install__no_command____shows_correct_menu() {
  _capture.output _pictl_cli install

  assert_snapshot "__fixtures__/install.txt"
}

test_pictl_cli__integration__install__no_command____return_code_127() {
  _capture.rc _pictl_cli install > /dev/null

  assert_rc "127"
}

test_pictl_cli__integration__install__help_command__shows_correct_menu() {
  _capture.output _pictl_cli install help

  assert_snapshot "__fixtures__/install.txt"
}

test_pictl_cli__integration__install__help_command__return_code_0() {
  _capture.rc _pictl_cli install help > /dev/null

  assert_rc "0"
}
