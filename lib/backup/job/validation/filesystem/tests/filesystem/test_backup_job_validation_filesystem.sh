#!/bin/bash

setup() {
  _mock.create _backup_job_validation_filesystem_keyfile
  _mock.create _backup_job_validation_filesystem_rsync
  _mock.create _backup_job_validation_filesystem_source
  _mock.create _backup_job_validation_filesystem_tarball
}

test_backup_job_validation_filesystem__validates_the_keyfile_path() {
  _backup_job_validation_filesystem

  _backup_job_validation_filesystem_keyfile.mock.assert_called_once_with ""
}

test_backup_job_validation_filesystem__validates_the_rsync_path() {
  _backup_job_validation_filesystem_rsync

  _backup_job_validation_filesystem_rsync.mock.assert_called_once_with ""
}

test_backup_job_validation_filesystem__validates_the_source_path() {
  _backup_job_validation_filesystem_source

  _backup_job_validation_filesystem_source.mock.assert_called_once_with ""
}

test_backup_job_validation_filesystem__validates_the_tarball_path() {
  _backup_job_validation_filesystem_tarball

  _backup_job_validation_filesystem_tarball.mock.assert_called_once_with ""
}
