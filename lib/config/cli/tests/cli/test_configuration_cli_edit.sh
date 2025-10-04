#!/bin/bash

# shellcheck disable=SC2034
setup_suite() {
  RPI_MANIFEST_CONFIG="$(mktemp)"
  RPI_MANIFEST_EDITOR="mock_editor"
}

teardown_suite() {
  rm "${RPI_MANIFEST_CONFIG}"
}

setup() {
  _mock.create stdlib.io.path.query.is_file
  _mock.create _io_colours_unload
  _mock.create _config_cli_details
  _mock.create _io_colours_load
  _mock.create stdlib.security.path.secure
  _mock.create _config_cli_check
  _mock.create mock_editor

  _config_cli_details.mock.set.stdout "mock config help"
}

test_config_cli_edit__file_exists__________does_not_template_a_config() {
  stdlib.io.path.query.is_file.mock.set.rc 0

  _config_cli_edit

  _config_cli_details.mock.assert_not_called
  stdlib.security.path.secure.mock.assert_not_called
}

test_config_cli_edit__file_exists__________edits_the_config() {
  stdlib.io.path.query.is_file.mock.set.rc 0

  _config_cli_edit

  mock_editor.mock.assert_called_once_with "1(${RPI_MANIFEST_CONFIG})"
}

test_config_cli_edit__file_exists__________checks_the_config() {
  stdlib.io.path.query.is_file.mock.set.rc 0

  _config_cli_edit

  _config_cli_check.mock.assert_called_once_with ""
}

test_config_cli_edit__file_does_not_exist__templates_a_new_config() {
  stdlib.io.path.query.is_file.mock.set.rc 1

  _config_cli_edit

  _config_cli_details.mock.assert_called_once_with ""
  stdlib.security.path.secure.mock.assert_called_once_with \
    "1(${RPI_MANIFEST_CONFIG}) 2(root) 3(root) 4(600)"
}

test_config_cli_edit__file_does_not_exist__new_config_has_expected_content() {
  stdlib.io.path.query.is_file.mock.set.rc 1

  _config_cli_edit

  assert_equals \
    "$(cat "${RPI_MANIFEST_CONFIG}")" \
    $'\n'"# mock config help"
}

test_config_cli_edit__file_does_not_exist__edits_the_new_config() {
  stdlib.io.path.query.is_file.mock.set.rc 1

  _config_cli_edit

  mock_editor.mock.assert_called_once_with "1(${RPI_MANIFEST_CONFIG})"
}

test_config_cli_edit__file_does_not_exist__checks_the_new_config() {
  stdlib.io.path.query.is_file.mock.set.rc 1

  _config_cli_edit

  _config_cli_check.mock.assert_called_once_with ""
}
