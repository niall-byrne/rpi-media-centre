#!/bin/bash

setup() {
  _mock.create _dependencies_requirement_manifest_editor
}

test_dependencies_group_manifest_cli_editor__calls_correct_dependency_function() {
  _dependencies_group_manifest_cli_editor

  _dependencies_requirement_manifest_editor.mock.assert_called_once_with ""
}
