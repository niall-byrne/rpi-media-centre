#!/bin/bash

setup() {
  _mock.create _dependencies_requirement_awscli
}

test_dependencies_group_backups_aws__calls_correct_dependency_function() {
  _dependencies_group_backups_aws

  _dependencies_requirement_awscli.mock.assert_called_once_with ""
}
