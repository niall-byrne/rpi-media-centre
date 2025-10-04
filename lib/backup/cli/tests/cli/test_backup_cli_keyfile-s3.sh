#!/bin/bash

setup_suite() {
  mock_key_file="$(mktemp)"
}

setup() {
  _mock.create _backup_cli_usage_error
  _mock.create _dependencies_group_backups_cli_keyfile
  _mock.create _cli_log_warning
  _mock.create _filesystem_resolve_path_relative_to_cli
  _mock.create stdlib.io.path.assert.not_exists
  _mock.create openssl
  _mock.create stdlib.security.path.secure
  _mock.create _cli_log_success

  _filesystem_resolve_path_relative_to_cli.mock.set.stdout "${mock_key_file}"
}

teardown_suite() {
  rm -f "${mock_key_file}"
}

test_backup_cli_keyfile_s3__no_filename_____calls_usage_error() {
  _backup_cli_keyfile-s3 ""

  _backup_cli_usage_error.mock.assert_called_once_with ""
}

test_backup_cli_keyfile_s3__valid_filename__calls_dependencies_in_sequence() {
  _mock.sequence.record.start

  _backup_cli_keyfile-s3 mock.key

  _mock.sequence.assert_is \
    "_dependencies_group_backups_cli_keyfile" \
    "_cli_log_warning" \
    "_filesystem_resolve_path_relative_to_cli" \
    "stdlib.io.path.assert.not_exists" \
    "openssl" \
    "stdlib.security.path.secure" \
    "_cli_log_success"
}

test_backup_cli_keyfile_s3__valid_filename__logs_warning_message() {
  _backup_cli_keyfile-s3 mock.key

  _cli_log_warning.mock.assert_called_once_with \
    "1(BACKUP SCHEDULER: Generating a new AWS S3 encryption key ...)"
}

test_backup_cli_keyfile_s3__valid_filename__resolves_key_file_into_absolute_path() {
  _backup_cli_keyfile-s3 mock.key

  _filesystem_resolve_path_relative_to_cli.mock.assert_called_once_with \
    "1(mock.key)"
}

test_backup_cli_keyfile_s3__valid_filename__asserts_key_file_does_not_exist() {
  _backup_cli_keyfile-s3 mock.key

  stdlib.io.path.assert.not_exists.mock.assert_called_once_with \
    "1(${mock_key_file})"
}

test_backup_cli_keyfile_s3__valid_filename__calls_openssl_correctly() {
  _backup_cli_keyfile-s3 mock.key

  openssl.mock.assert_called_once_with \
    "1(rand) 2(-out) 3(${mock_key_file}) 4(32)"
}

test_backup_cli_keyfile_s3__valid_filename__secures_file_permissions_correctly() {
  _backup_cli_keyfile-s3 mock.key

  stdlib.security.path.secure.mock.assert_called_once_with \
    "1(${mock_key_file}) 2(root) 3(root) 4(600)"
}

test_backup_cli_keyfile_s3__valid_filename__logs_success_message() {
  _backup_cli_keyfile-s3 mock.key

  _cli_log_success.mock.assert_called_once_with \
    "1(BACKUP SCHEDULER: Successfully generated 'mock.key' !)"
}
