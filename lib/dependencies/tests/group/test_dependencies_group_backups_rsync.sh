#!/bin/bash

setup() {
  _mock.create _dependencies_requirement_generic
}

test_dependencies_group_backups_rsync__calls_correct_dependency_function() {
  _dependencies_group_backups_rsync

  _dependencies_requirement_generic.mock.assert_calls_are \
    "1(rsync)"
}
