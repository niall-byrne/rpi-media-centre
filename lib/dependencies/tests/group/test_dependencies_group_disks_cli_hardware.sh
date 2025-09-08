#!/bin/bash

setup() {
  _mock.create _dependencies_enforce
  _mock.create _dependencies_requirement_generic
}

test_dependencies_group_disks_cli_hardware__calls_correct_dependency_functions() {
  _dependencies_group_disks_cli_hardware

  _dependencies_requirement_generic.mock.assert_calls_are \
    "1(hdparm)"

  _dependencies_enforce.mock.assert_calls_are \
    "1(lsblk) 2(The application lsblk) 3(Please consider running: sudo apt-get install util-linux)"
}
