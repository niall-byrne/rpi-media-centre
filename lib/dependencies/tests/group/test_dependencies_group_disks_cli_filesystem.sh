#!/bin/bash

setup() {
  _mock.create _dependencies_enforce
}

test_dependencies_group_disks_cli_filesystem__calls_correct_dependency_function() {
  _dependencies_group_disks_cli_filesystem

  _dependencies_enforce.mock.assert_calls_are \
    "1(lsblk) 2(The application lsblk) 3(Please consider running: sudo apt-get install util-linux)"
}
