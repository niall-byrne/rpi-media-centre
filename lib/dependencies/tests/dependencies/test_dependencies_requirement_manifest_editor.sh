#!/bin/bash

setup() {
  _mock.create _dependencies_enforce
}

@parametrize_with_manifest_editor_scenarios() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "RPI_MANIFEST_EDITOR_VALUE;TEST_EXPECTED_ARGS_RAW" \
    "default_vi_editor;/usr/bin/vi;1(/usr/bin/vi) 2(The application vim) 3(Please consider running: sudo apt-get install vim)" \
    "custom_editor____;/usr/bin/my_editor;1(/usr/bin/my_editor) 2(The configured manifest editor) 3(Please install it or review the value of RPI_MANIFEST_EDITOR.)"
}

# shellcheck disable=SC2034
test_dependencies_requirement_manifest_editor__@vary__enforce_is_called_with_correct_arguments() {

  local RPI_MANIFEST_EDITOR="${RPI_MANIFEST_EDITOR_VALUE}"
  local expected_args="${TEST_EXPECTED_ARGS_RAW}"

  _dependencies_requirement_manifest_editor

  _dependencies_enforce.mock.assert_calls_are "${expected_args}"
}

@parametrize_with_manifest_editor_scenarios \
  test_dependencies_requirement_manifest_editor__@vary__enforce_is_called_with_correct_arguments
