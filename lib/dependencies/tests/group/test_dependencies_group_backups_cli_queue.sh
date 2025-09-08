#!/bin/bash

setup() {
  _mock.create _dependencies_requirement_generic
}

test_dependencies_group_backups_cli_queue__calls_correct_dependency_function() {
  _dependencies_group_backups_cli_queue

  _dependencies_requirement_generic.mock.assert_calls_are \
    "1(tree)"
}
