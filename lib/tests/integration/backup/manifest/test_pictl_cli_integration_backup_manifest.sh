#!/bin/bash

test_pictl_cli__integration__backup_manifest__no_command____shows_correct_menu() {
  _capture.output _pictl_cli backup manifest

  assert_snapshot "__fixtures__/backup_manifest.txt"
}

test_pictl_cli__integration__backup_manifest__no_command____return_code_127() {
  _capture.rc _pictl_cli backup manifest > /dev/null

  assert_rc "127"
}

test_pictl_cli__integration__backup_manifest__help_command__shows_correct_menu() {
  _capture.output _pictl_cli backup manifest help

  assert_snapshot "__fixtures__/backup_manifest.txt"
}

test_pictl_cli__integration__backup_manifest__help_command__return_code_0() {
  _capture.rc _pictl_cli backup manifest help > /dev/null

  assert_rc "0"
}
