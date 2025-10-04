#!/bin/bash

# shellcheck disable=SC2034
setup_suite() {
  RPI_MANIFEST_BACKUP="$(mktemp)"
  RPI_MANIFEST_EDITOR="mock_editor"
}

teardown_suite() {
  rm "${RPI_MANIFEST_BACKUP}"
}

setup() {
  _mock.create stdlib.io.path.query.is_file
  _mock.create _io_colours_unload
  _mock.create _backup_cli_manifest_cli_details
  _mock.create _io_colours_load
  _mock.create stdlib.security.path.secure
  _mock.create _backup_cli_manifest_cli_check
  _mock.create mock_editor

  _backup_cli_manifest_cli_details.mock.set.stdout "mock manifest help"
}

test_backup_cli_manifest_cli_edit__file_exists__________does_not_template_a_manifest() {
  stdlib.io.path.query.is_file.mock.set.rc 0

  _backup_cli_manifest_cli_edit

  _backup_cli_manifest_cli_details.mock.assert_not_called
  stdlib.security.path.secure.mock.assert_not_called
}

test_backup_cli_manifest_cli_edit__file_exists__________edits_the_manifest() {
  stdlib.io.path.query.is_file.mock.set.rc 0

  _backup_cli_manifest_cli_edit

  mock_editor.mock.assert_called_once_with "1(${RPI_MANIFEST_BACKUP})"
}

test_backup_cli_manifest_cli_edit__file_exists__________checks_the_manifest() {
  stdlib.io.path.query.is_file.mock.set.rc 0

  _backup_cli_manifest_cli_edit

  _backup_cli_manifest_cli_check.mock.assert_called_once_with ""
}

test_backup_cli_manifest_cli_edit__file_does_not_exist__templates_a_new_manifest() {
  stdlib.io.path.query.is_file.mock.set.rc 1

  _backup_cli_manifest_cli_edit

  _backup_cli_manifest_cli_details.mock.assert_called_once_with ""
  stdlib.security.path.secure.mock.assert_called_once_with \
    "1(${RPI_MANIFEST_BACKUP}) 2(root) 3(root) 4(600)"
}

test_backup_cli_manifest_cli_edit__file_does_not_exist__new_manifest_has_expected_content() {
  stdlib.io.path.query.is_file.mock.set.rc 1

  _backup_cli_manifest_cli_edit

  assert_equals \
    "$(cat "${RPI_MANIFEST_BACKUP}")" \
    $'\n'"# mock manifest help"
}

test_backup_cli_manifest_cli_edit__file_does_not_exist__edits_the_new_manifest() {
  stdlib.io.path.query.is_file.mock.set.rc 1

  _backup_cli_manifest_cli_edit

  mock_editor.mock.assert_called_once_with "1(${RPI_MANIFEST_BACKUP})"
}

test_backup_cli_manifest_cli_edit__file_does_not_exist__checks_the_new_manifest() {
  stdlib.io.path.query.is_file.mock.set.rc 1

  _backup_cli_manifest_cli_edit

  _backup_cli_manifest_cli_check.mock.assert_called_once_with ""
}
